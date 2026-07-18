# Release procedure

This document defines the maintainer procedure for preparing a `kanban`
release. It supplements `CONTRIBUTING.md`; it is not part of the public package
interface.

## 1. Establish the release state

Begin from a clean working tree on the intended release branch. Confirm that
all user-visible changes are represented in `CHANGELOG.md`, that the public API
described in `README.md` agrees with `kanban.dtx`, and that the LPPL work lists
in `kanban.dtx` and `LICENSE` name the same distributed files.

As part of that comparison, inventory the public commands, concise aliases,
package and board keys, accepted values, built-in defaults, reset behavior,
canonical stored-date behavior, reference-date reproducibility, diagnostic
recovery, public style hooks, and renderer-specific limitations.
Every documented stable contract should have a corresponding regression test
where an engine-independent assertion is practical.

Use semantic versioning for the public version number. Update the version and
date through the project tagging support rather than editing derived files:

```text
l3build tag --date YYYY-MM-DD X.Y.Z
```

Inspect the resulting changes before proceeding. `kanban.sty` is generated
from `kanban.dtx`; it must not become an independent source of edits.

## 2. Run the reproducible build

Remove output from preceding builds and run the complete release sequence:

```text
l3build clean
l3build unpack
l3build check
l3build doc
l3build ctan
```

The regression suite must pass with pdfTeX, LuaTeX, and XeTeX. Confirm that the
canonical start-date and fixed-reference-date cases pass before reviewing any
rendered deadline colors. The declared
minimum LaTeX format is covered by the compatibility test; an actual TeX Live
2020 build must also pass before publication. The repository workflow provides
that historical-distribution job when continuous integration is available.

Compile every standalone example twice with pdfLaTeX, LuaLaTeX, and XeLaTeX. A
second run is required because equal-height measurements may be written to
auxiliary files. No example log may contain a LaTeX error, an undefined control
sequence, an unresolved reference, or an overfull box.

## 3. Review the manual visually

Inspect `build/doc/kanban.pdf`, not a PDF left from an earlier build. Review at
least the title page, table of contents, first fixed board, deadline comparison,
date-format comparison, custom palette, dark-mode board, page-breakable
example, landscape page, implementation listing, change history, and index.

Confirm that:

- headings and fixed column bottoms align;
- cards fill their available column width;
- light and dark card text remains readable;
- author and deadline chips retain their documented cross-mode styling;
- every date-format example uses the documented component order;
- fixed reference-date examples retain identical deadline states on rebuild;
- semantic and heading color pairs have adequate contrast;
- code listings have the documented light-gray background;
- no page contains clipped, overlapping, or orphaned board material;
- page numbers, running heads, bookmarks, and links are correct.

Rendered page images may be produced with Poppler for systematic comparison:

```text
mkdir -p tmp/release-pages
pdftoppm -png -r 144 build/doc/kanban.pdf tmp/release-pages/kanban
```

The images are review material and must not be added to the release archive.
The current-distribution workflow performs the same rasterization when Poppler
is available and retains the resulting PNG files with the build artifacts. It
also checks that the manual has a plausible page count and that non-empty
raster output was produced. These are smoke checks, not pixel-exact baselines:
font rasterization and PDF backend details legitimately differ across supported
TeX Live releases. Layout dimensions and pagination invariants remain covered
by the engine-independent `l3build` regression tests, while the raster files
support a deliberate human review of appearance.

## 4. Inspect the archives

Verify both generated archives before upload:

```text
unzip -t kanban-ctan.zip
unzip -t kanban.tds.zip
unzip -l kanban-ctan.zip
unzip -l kanban.tds.zip
```

The CTAN archive must contain the documented source, installer, build
configuration, readme, licence and maintenance documents, examples, complete
regression suite, manual, and nested TDS archive. It must not contain build
directories, auxiliary files, local logs, or repository metadata.

Extract the CTAN archive into a fresh temporary directory and run at least one
engine of the regression suite from that extraction. This verifies that the
published source is self-contained rather than relying on files left in the
maintainer's working tree.

## 5. Publish and record the release

Upload `kanban-ctan.zip` through the CTAN submission interface. Use the package
summary and licence information from the manual and identify the package as an
update after its initial publication. Retain the submission confirmation.

After the accepted archive is visible on CTAN, create an annotated Git tag
named `vX.Y.Z` from the exact reviewed commit and publish a repository release
containing the CTAN archive, TDS archive, and manual. The release notes should
summarize `CHANGELOG.md` and identify any compatibility change explicitly.

If a defect is discovered before CTAN acceptance, correct it, increment the
release date as necessary, and repeat the complete procedure. Do not replace a
reviewed archive without rebuilding and rechecking it.
