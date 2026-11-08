# Contributing to `kanban-board`

Thank you for helping to improve `kanban-board`. Development takes place in the
[public repository](https://github.com/andreaswillibaldweber/ctan-kanban).
Defects and focused enhancement proposals belong in the
[public issue tracker](https://github.com/andreaswillibaldweber/ctan-kanban/issues).

## Reporting a defect

A useful report lets another contributor reproduce the problem without
guessing. Please provide the following items.

1. A minimal complete LaTeX document.
2. The complete `.log` file produced by the failing run.
3. The `kanban-board` version, the TeX engine, and the TeX distribution release.
4. The observed result and the result that was expected.
5. A PDF or screenshot when the defect concerns visual layout.

Remove confidential task data before attaching a document or log. Search the
existing issues before opening a new one, but open a separate issue when two
problems have different minimal examples or causes.

## Source of record

The documented source is split into `kanban-board.dtx`, which holds the
driver, the user manual, and the bootstrap code, and the subsystem parts
`kanban-board-registry.dtx`, `kanban-board-dates.dtx`,
`kanban-board-config.dtx`, `kanban-board-render.dtx`, and
`kanban-board-lifecycle.dtx`. The installer `kanban-board.ins` assembles them
in that order into the generated package. Do not edit the generated
`kanban-board.sty` directly. The example documents are maintained as separate
`.tex` files in `examples/` because they are also compiled as end-to-end
demonstrations. `kanban-board.pdf`, `kanban-board.sty`, and the ZIP archive
are release artifacts regenerated from these sources.

## Local verification

The project uses `l3build`. A proposed implementation change should pass the
following commands.

```sh
l3build check
l3build doc
l3build ctan
```

`l3build check` executes the regression suite with pdfTeX, LuaTeX, and XeTeX.
One test, `strict.lvt`, runs with expl3 declaration and deprecation checking
enabled, so undeclared variables and deprecated functions fail the suite.
Add or update an `.lvt` file and its normalized `.tlg` file whenever public
behaviour, diagnostics, date parsing or formatting, classification, or layout
invariants change. Date-related changes must exercise every affected format,
ambiguous component order, canonical stored-date snapshot, and reference-date
scope. Input-validation changes should demonstrate that malformed data
produces the package diagnostic rather than a secondary TeX scanner error.
Read and justify every changed `.tlg` before accepting it.

The documentation build must complete without a LaTeX error, an undefined
control sequence, an unresolved reference, or an overfull box. Compile every
affected standalone example as well. For a visual change, inspect the
rendered manual and example PDFs. Source inspection alone is not sufficient.

The continuous-integration workflow repeats these checks on a current TeX
Live installation and on TeX Live 2020, the release that contains the
declared minimum LaTeX format. It retains the manual and example PDFs as
review artifacts, produces PNG review pages when Poppler is available, and
verifies that the CTAN archive contains the regression suite. Raster files
support visual review but are not treated as pixel-exact baselines across
different TeX and PDF-renderer versions.

## Documentation and interface changes

Write user documentation and source commentary in direct, formal language.
Use short declarative sentences. Do not join clauses with semicolons or
dashes. Define a command before using it in an extended example, state
whether a setting is persistent or board-local, and document recovery after
invalid input. Source commentary explains the responsibility of a definition
and the reasons for its design. It does not restate the semantics of the
LaTeX3 programming layer.

Canonical public control sequences use the `kanban-board` prefix. A proposed
concise `kb` alias must remain optional and must not overwrite a command
owned by a class or another package. Package code allocates its own LaTeX3
variables and does not use the scratch variables of the kernel.

Compatibility is part of the public interface. Removing or changing a key, a
command signature, a default, a diagnostic category, or a visual semantic
requires a clear rationale and a changelog entry. Prefer a deprecation period
to an immediate incompatible change.

Check documentation changes against the generated `kanban-board.sty`, not only
against earlier prose. In particular, review command aliases, accepted key
values, configuration scope, canonical date storage, reference-date
reproducibility, reset behavior, diagnostic recovery, renderer limitations,
and public style hooks. When behavior is documented as a stable contract, add
or update an `l3build` assertion in the same change.

## Pull requests

Keep each pull request focused. Describe the user-visible effect, identify
the tests that cover it, and include before-and-after pages or crops for a
layout change. Do not include unrelated generated files or local build
directories. Before requesting review, confirm that all three `l3build`
commands above have completed successfully.

Contributions are distributed under the LaTeX Project Public License stated
in `LICENSE`. By submitting a contribution, you confirm that you have the
right to provide it under those terms.

The archive preparation, visual review, and publication checklist of the
maintainer is recorded in `RELEASING.md`.
