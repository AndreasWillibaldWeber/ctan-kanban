# Release procedure

This document defines the maintainer procedure for preparing a `kanban-board`
release. It supplements `CONTRIBUTING.md` and is not part of the public
package interface. It stays in the development repository and is not
included in the CTAN archive.

## 1. Establish the release state

Begin from a clean working tree on the intended release branch. Confirm that
all user-visible changes are represented in `CHANGELOG.md`, that the public
API described in the manual agrees with the generated `kanban-board.sty`, and
that the LPPL work lists in `kanban-board.dtx`, `kanban-board.ins`, and
`LICENSE` name the same distributed files.

As part of that comparison, inventory the public commands, concise aliases,
package and board keys, accepted values, built-in defaults, reset behavior,
canonical stored-date behavior, reference-date reproducibility, diagnostic
recovery, public style hooks, and renderer-specific limitations. Every
documented stable contract should have a corresponding regression test where
an engine-independent assertion is practical.

Use semantic versioning for the public version number. On the day of the
upload, set the version and the release date through the project tagging
support rather than by editing derived files.

```text
l3build tag --date YYYY-MM-DD X.Y.Z
```

The command rewrites every location that carries the version or the date:
the package declaration and the change history entry in `kanban-board.dtx`, the
release line in `README.md`, the heading of the tagged version in
`CHANGELOG.md`, and the version placeholder in the issue template. The
version number is mandatory. Continuous integration fails when these
locations disagree, so a forgotten run cannot reach an upload. Inspect the
diff before proceeding. `kanban-board.sty` is generated from the `.dtx` files
and must not become an independent source of edits.

## 2. Run the reproducible build

Remove output from preceding builds and run the complete release sequence.

```text
l3build clean
l3build unpack
l3build check
l3build doc
l3build ctan
```

The regression suite must pass with pdfTeX, LuaTeX, and XeTeX, including the
strict test that enables expl3 declaration and deprecation checking. Confirm
that the canonical start-date and fixed-reference-date cases pass before
reviewing any rendered deadline colors. The declared minimum LaTeX format is
covered by the compatibility test. An actual TeX Live 2020 build must also
pass before publication. The repository workflow provides that
historical-distribution job.

Compile every standalone example twice with pdfLaTeX, LuaLaTeX, and XeLaTeX.
A second run is required because equal-height measurements are written to
auxiliary files. No example log may contain a LaTeX error, an undefined
control sequence, an unresolved reference, or an overfull box.

## 3. Review the manual visually

Inspect `build/doc/kanban-board.pdf`, not a PDF left from an earlier build.
Review at least the title page, the table of contents, the first fixed board,
the deadline comparison, the date-format comparison, the custom palette, the
dark-mode board, the page-breakable example, the landscape page, the
implementation listing, the change history, and the index.

Confirm the following points.

- Headings and fixed column bottoms align.
- Cards fill their available column width.
- Light and dark card text remains readable.
- Author and deadline chips retain their documented cross-mode styling.
- Every date-format example uses the documented component order.
- Fixed reference-date examples retain identical deadline states on rebuild.
- Semantic and heading color pairs have adequate contrast.
- Code listings have the documented light-gray background.
- No page contains clipped, overlapping, or orphaned board material.
- Page numbers, running heads, bookmarks, and links are correct.
- The index lists expl3 functions as complete names and contains no name
  fragments.

Rendered page images may be produced with Poppler for systematic comparison.

```text
mkdir -p tmp/release-pages
pdftoppm -png -r 144 build/doc/kanban-board.pdf tmp/release-pages/kanban-board
```

The images are review material and must not be added to the release
archive. The current-distribution workflow performs the same rasterization
when Poppler is available and retains the resulting PNG files with the build
artifacts. These are smoke checks, not pixel-exact baselines. Font
rasterization and PDF backend details legitimately differ across supported
TeX Live releases.

## 4. Inspect the archive

Verify the generated CTAN archive before upload.

```text
unzip -t kanban-board.zip
unzip -l kanban-board.zip
```

The archive must contain the documented source, the installer, the build
configuration, the readme, the changelog, the dependency list, the licence
file, the examples, the complete regression suite, and the manual. It must
not contain build directories, auxiliary files, local logs, or repository
metadata. `l3build ctan` also assembles a TDS tree below `build/distrib/tds`
for local inspection. CTAN does not require a TDS archive for a package with
a standard layout, so no such archive is part of the upload.

Extract the CTAN archive into a fresh temporary directory and run at least
one engine of the regression suite from that extraction. This verifies that
the published source is self-contained rather than relying on files left in
the working tree of the maintainer.

## 5. Publish and record the release

Upload `kanban-board.zip` through the CTAN submission interface. Use the
package summary and licence information from the manual and identify the
package as an update after its initial publication. Retain the submission
confirmation.

After the accepted archive is visible on CTAN, create an annotated Git tag
named `vX.Y.Z` from the exact reviewed commit and publish a repository
release containing the CTAN archive and the manual. The release notes should
summarize `CHANGELOG.md` and identify any compatibility change explicitly.

If a defect is discovered before CTAN acceptance, correct it, update the
release date as necessary, and repeat the complete procedure. Do not replace
a reviewed archive without rebuilding and rechecking it.
