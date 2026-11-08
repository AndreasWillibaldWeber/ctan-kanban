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
  "CHANGELOG.md",
  "DEPENDS.txt",
  "LICENSE"
}
-- CTAN does not require a TDS archive for a package with a standard layout.
-- The TDS tree is still assembled below build/distrib/tds for inspection.
packtdszip = false
-- Every file that carries the release version or date. One l3build tag
-- call rewrites all of them, and the CI workflow checks that they agree.
tagfiles = {
  "kanban.dtx",
  "README.md",
  "CHANGELOG.md",
  ".github/ISSUE_TEMPLATE/bug_report.yml"
}

-- Ship the regression suite in the CTAN archive without making it part of
-- the docstrip unpacking input. The latter would make l3build discover
-- duplicate tests in testfiledir and unpackdir.
assert(type(copyctan) == "function",
  "kanban: this l3build release does not provide copyctan()")
local standard_copyctan = copyctan
function copyctan()
  standard_copyctan()
  assert(fileexists(ctandir .. "/" .. ctanpkg .. "/kanban-board.dtx"),
    "kanban: CTAN archive is missing the split source parts")
  assert(fileexists(ctandir .. "/" .. ctanpkg .. "/DEPENDS.txt"),
    "kanban: CTAN archive is missing the dependency list")
  local ctan_testdir = ctandir .. "/" .. ctanpkg .. "/testfiles"
  mkdir(ctan_testdir)
  for _, pattern in ipairs({"*.lvt", "*.tlg"}) do
    cp(pattern, testfiledir, ctan_testdir)
  end
  assert(fileexists(ctan_testdir .. "/strict.lvt"),
    "kanban: CTAN archive is missing the regression suite")
end

function update_tag(file, content, tagname, tagdate)
  assert(tagname,
    "kanban: l3build tag needs a version number, for example 1.0.0")
  local slashdate = string.gsub(tagdate, "-", "/")
  -- The version is used inside Lua patterns, so its dots must be escaped.
  local version_pattern = string.gsub(tagname, "%p", "%%%0")
  if file == "kanban.dtx" then
    content = string.gsub(
      content,
      "\\ProvidesPackage{kanban}%b[]",
      "\\ProvidesPackage{kanban}[" .. slashdate .. " v" ..
        tagname .. " Kanban project boards]"
    )
    content = string.gsub(
      content,
      "\\changes{v" .. version_pattern .. "}{%d%d%d%d/%d%d/%d%d}",
      "\\changes{v" .. tagname .. "}{" .. slashdate .. "}"
    )
  elseif file == "README.md" then
    content = string.gsub(
      content,
      "Current release: %*%*[^*]+%*%* %([^%)]+%)",
      "Current release: **" .. tagname .. "** (" .. tagdate .. ")"
    )
  elseif file == "CHANGELOG.md" then
    -- Only the heading of the tagged version changes. Older releases keep
    -- their dates.
    content = string.gsub(
      content,
      "## " .. version_pattern .. " %([^%)]+%)",
      "## " .. tagname .. " (" .. tagdate .. ")"
    )
  elseif file == "bug_report.yml" then
    content = string.gsub(
      content,
      "placeholder: %d+%.%d+%.%d+ %([^%)]+%)",
      "placeholder: " .. tagname .. " (" .. tagdate .. ")"
    )
  end
  return content
end
