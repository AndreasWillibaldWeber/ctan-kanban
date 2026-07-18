# Contributing to `kanban`

Thank you for helping to improve `kanban`. Development takes place in the
[public repository](https://www.github.com/andreaswillibaldweber/ctan-kanban).
Defects and focused enhancement proposals belong in the
[public issue tracker](https://www.github.com/andreaswillibaldweber/ctan-kanban/issues).

## Reporting a defect

A useful report permits another contributor to reproduce the problem without
guessing. Please provide:

1. a minimal complete LaTeX document;
2. the complete `.log` file produced by the failing run;
3. the `kanban` version, TeX engine, and TeX distribution release;
4. the observed result and the result that was expected; and
5. a PDF or screenshot when the defect concerns visual layout.

Remove confidential task data before attaching a document or log. Search the
existing issues before opening a new one, but open a separate issue when two
problems have different minimal examples or causes.

## Source of record

`kanban.dtx` is the maintained source for both the package implementation and
the manual. Do not edit the generated `kanban.sty` directly. The example
documents are maintained as separate `.tex` files because they are also
compiled as end-to-end demonstrations. `kanban.pdf`, `kanban.sty`, and the ZIP
archives are release artifacts regenerated from these sources.

## Local verification

The project uses `l3build`. A proposed implementation change should pass:

```sh
l3build check
l3build doc
l3build ctan
```

`l3build check` executes the regression suite with pdfTeX, LuaTeX, and XeTeX.
Add or update an `.lvt` and its normalized `.tlg` whenever public behaviour,
diagnostics, date parsing or formatting, classification, or layout invariants
change. Date-related changes must exercise every affected format, ambiguous
component order, canonical stored-date snapshot, and reference-date scope.
Input-validation changes should demonstrate that malformed data produces the
package diagnostic rather than a secondary TeX scanner error. Avoid accepting
a changed `.tlg` until the difference has been read and justified.

The documentation build must complete without a LaTeX error, an undefined
control sequence, an unresolved reference, or an overfull box. Compile every
affected standalone example as well. For a visual change, inspect the rendered
manual and example PDFs; source inspection alone is not sufficient.

The continuous-integration workflow repeats these checks on a current TeX Live
installation and on TeX Live 2020, the release that contains the declared
minimum LaTeX format. It retains the manual and example PDFs as review
artifacts, produces PNG review pages when Poppler is available, and verifies
that the CTAN archive contains the regression suite. Raster files support
visual review but are not treated as pixel-exact baselines across different
TeX and PDF-renderer versions.

## Documentation and interface changes

Write user documentation in direct, formal language. Define a command before
using it in an extended example, state whether settings are persistent or
board-local, and document recovery after invalid input. Canonical public
control sequences should use the `kanban` prefix. A proposed concise `kb`
alias must remain optional and must not overwrite a command owned by a class
or another package.

Compatibility is part of the public interface. Removing or changing a key,
command signature, default, diagnostic category, or visual semantic requires a
clear rationale and a changelog entry. Prefer a deprecation period to an
immediate incompatible change.

Documentation changes must be checked against the generated `kanban.sty`, not
only against earlier prose. In particular, review command aliases, accepted key
values, configuration scope, canonical date storage, reference-date
reproducibility, reset behavior, diagnostic recovery, renderer limitations,
and public style hooks. When behavior is documented as a stable
contract, add or update an `l3build` assertion in the same change.

## Pull requests

Keep each pull request focused. Describe the user-visible effect, identify the
tests that cover it, and include before-and-after pages or crops for a layout
change. Do not include unrelated generated files or local build directories.
Before requesting review, confirm that all three `l3build` commands above have
completed successfully.

Contributions are distributed under the LaTeX Project Public License stated in
`LICENSE`. By submitting a contribution, you confirm that you have the right to
provide it under those terms.

The maintainer's archive preparation, visual review, and publication checklist
is recorded in `RELEASING.md`.
