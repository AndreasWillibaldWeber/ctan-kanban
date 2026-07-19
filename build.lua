module = "kanban"
sourcefiles = {
  "*.dtx",
  "*.ins",
  "build.lua"
}
excludefiles = {"*~", "config-*.lua"}
installfiles = {"*.sty"}
typesetfiles = {"kanban.dtx"}
typesetexe = "pdflatex"
typesetopts = "-interaction=nonstopmode"
checkengines = {"pdftex", "luatex", "xetex"}
checkruns = 2
testfiledir = "testfiles"
demofiles = {"examples/kanban-example.tex", "examples/kanban-*-example.tex"}
textfiles = {
  "README.md",
  "CONTRIBUTING.md",
  "RELEASING.md",
  "CHANGELOG.md",
  "LICENSE"
}
packtdszip = true
tagfiles = {"kanban.dtx", "README.md"}

-- Keep the CTAN source archive self-testing without making the regression
-- files part of the docstrip unpacking input.  The latter would make l3build
-- discover duplicate tests in testfiledir and unpackdir.
assert(type(copyctan) == "function",
  "kanban: this l3build release does not provide copyctan()")
local standard_copyctan = copyctan
function copyctan()
  standard_copyctan()
  assert(fileexists(ctandir .. "/" .. ctanpkg .. "/RELEASING.md"),
    "kanban: CTAN archive is missing the release procedure")
  local ctan_testdir = ctandir .. "/" .. ctanpkg .. "/testfiles"
  local tds_testdir = tdsdir .. "/source/" .. tdsroot .. "/" ..
    module .. "/testfiles"
  mkdir(ctan_testdir)
  mkdir(tds_testdir)
  for _, pattern in ipairs({"*.lvt", "*.tlg"}) do
    cp(pattern, testfiledir, ctan_testdir)
    cp(pattern, testfiledir, tds_testdir)
  end
  assert(fileexists(ctan_testdir .. "/compatibility.lvt"),
    "kanban: CTAN archive is missing the regression suite")
  assert(fileexists(tds_testdir .. "/compatibility.lvt"),
    "kanban: TDS archive is missing the regression suite")
end

function update_tag(file, content, tagname, tagdate)
  local slashdate = string.gsub(tagdate, "-", "/")
  if file == "kanban.dtx" then
    content = string.gsub(
      content,
      "\\ProvidesPackage{kanban}%b[]",
      "\\ProvidesPackage{kanban}[" .. slashdate .. " v" ..
        tagname .. " Kanban project boards]"
    )
  elseif file == "README.md" then
    content = string.gsub(
      content,
      "Current release: %*%*[^*]+%*%* %([^%)]+%)",
      "Current release: **" .. tagname .. "** (" .. tagdate .. ")"
    )
  end
  return content
end
