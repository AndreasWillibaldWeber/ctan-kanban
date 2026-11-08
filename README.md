# kanban-board

Current release: **1.0.0** (2026-11-15)

`kanban-board` typesets Kanban project boards in LaTeX. A board consists of
named columns and task cards. Each card may carry a priority, an author, a
deadline, and a completion marker. Deadlines are classified as overdue, due
now, or upcoming, either against the compilation date or against a fixed
reference date for reproducible builds. Project-relative deadlines such as
`M2` are supported as well.

## Features

- Fixed horizontal boards with synchronized headings and column bodies, and
  page-breakable boards built on `paracol`.
- Light and dark card modes, built-in and user-defined color palettes, and a
  configurable gap between columns.
- Calendar deadlines in US, English, German, ISO, and year-first notation
  with Gregorian validation, and project months relative to a start date.
- A three-level configuration hierarchy of package options, `\kanbansetup`,
  and board options.
- Configurable semantic labels and namespaced `tcolorbox` style hooks.

## Minimal example

```latex
\documentclass{article}
\usepackage[reference-date=2026-07-18]{kanban-board}
\begin{document}
\begin{kanban}
  \kanbantask[prio=high,author=Alice]{Backlog}{Design the API}
  \kanbantask[due=2026-07-31]{Doing}{Write the implementation}
  \kanbantask[completed]{Done}{Create the repository}
\end{kanban}
\end{document}
```

Without a `columns` option, a board uses the built-in columns `Backlog`,
`Doing`, and `Done`. Task targets are matched without regard to letter case,
and headings keep the spelling of the column list. The board option `break`
selects the page-breakable layout.

## Installation

TeX Live and MiKTeX install the package automatically once it is part of the
distribution. For a manual installation, run

```text
latex kanban-board.ins
```

and place `kanban-board.sty` in a directory searched by TeX, for example below
`TEXMFHOME/tex/latex/kanban-board`.

## Documentation

The user manual `kanban-board.pdf` describes the complete interface, the date
model, the configuration hierarchy, and the diagnostics. It is generated
from `kanban-board.dtx` with `l3build doc`. Eight standalone examples accompany
the manual. The source archive also contains the regression suite, which
runs with `l3build check`.

## Requirements

The package requires LaTeX 2020-10-01 or later and the packages `xcolor`,
`etoolbox`, `tikz`, `tcolorbox`, and `paracol`. On formats older than
2021-06-01 it additionally loads `kvoptions`. The regression suite runs with
pdfTeX, LuaTeX, and XeTeX.

## Reporting problems

Please include a minimal complete document, the relevant log output, and the
versions of LaTeX and `kanban-board`. Development takes place in the
[public repository](https://github.com/andreaswillibaldweber/ctan-kanban).
Defects and enhancement proposals belong in its
[issue tracker](https://github.com/andreaswillibaldweber/ctan-kanban/issues).
The maintainer is reached through the issue tracker.

## License

This material is subject to the LaTeX Project Public License, version 1.3c
or, at your option, any later version. It has LPPL maintenance status
`maintained`. The Current Maintainer is Andreas Willibald Weber.
