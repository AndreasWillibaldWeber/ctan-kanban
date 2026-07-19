# kanban

Current release: **1.0.0** (2026-07-18)

`kanban` is a LaTeX package for compact project boards. It typesets named
columns and task cards with automatic counts, priorities, authors, deadlines,
and completion markers. Boards may use either a fixed horizontal layout or a
page-breakable parallel-column layout, in light or dark mode.

Calendar deadlines are classified relative to the compilation date by default;
a fixed reference date can be selected for reproducible reports and automated
builds. The package also supports project-relative deadlines such as `M2`, where project
months are calculated from a configurable start date. Valid calendar dates can
be displayed in US, English, German, ISO, or slash-separated year-first form;
US notation is the default. Named, arbitrary-length color palettes can be
selected globally or for an individual board.
Task cards fill the available column body, and the separation between columns
is configurable. Column bodies are transparent in both visual modes, while
individual cards retain their light or dark background.

## Installation

Run:

```text
latex kanban.ins
```

Then place `kanban.sty` in a directory searched by TeX. No manual installation
is required when the package is installed through a TeX distribution.

The CTAN source archive includes `build.lua` and the complete `testfiles`
directory. From the root of that archive, development and release validation
can therefore be reproduced with:

```text
l3build clean
l3build unpack
l3build check
l3build doc
l3build ctan
```

The release configuration validates the regression suite with pdfTeX,
LuaTeX, and XeTeX and creates both the CTAN source archive and a TDS archive.
Continuous integration repeats the build on current TeX Live and TeX Live
2020, retains rendered PDFs for review, and checks the archive contents.

## Minimal example

```latex
\begin{kanban}
  \kanbantask[prio=high,author=Alice]{Backlog}{Design the API}
  \kanbantask[due=07/31/2026]{Doing}{Write the implementation}
  \kanbantask[completed]{Done}{Create the repository}
\end{kanban}
```

Add the board option `break` for a page-breakable `paracol` layout.
Project-month deadlines such as `M2` require a valid project start date,
supplied as a package, setup, or board option.
When the `columns` board option is omitted, the built-in
`BACKLOG,DOING,DONE` list is used. Column declarations and task targets are
normalized to uppercase, so task assignment is case-insensitive.

## Interface summary

Board options:

- `break`: allow long boards to continue across pages;
- `columns={<name>,<name>,...}`: select columns for one board;
- `date-format=us|english|german|iso|ymd`: select calendar-date output for one
  board;
- `startdate=<date>`: set a validated calendar start date for project-month
  deadlines;
- `reference-date=<date>` or `today=<date>`: fix the comparison date for
  reproducible deadline classification;
- `palette=<name>`: select a palette for one board;
- `mode=light|dark`: select a visual mode for one board;
- `columnsep=<length>`: set the gap between columns for one board;
- `labels={high=...,medium=...,low=...,done=...}`: replace semantic labels for
  one board.

The `break` key is intentionally board-local. It is not a package option or a
document setup key.

Document setup keys accepted by package options and `\kanbansetup` (also
available as the concise alias `\kbset` when that name is unused):

- `columns={<name>,<name>,...}`: set the default columns for later boards;
- `palette=<name>`;
- `mode=light|dark`;
- `date-format=us|english|german|iso|ymd`;
- `startdate=<date>` in any supported calendar notation;
- `reference-date=<date>` or its exact alias `today=<date>`;
- `columnsep=<length>`;
- `labels={high=...,medium=...,low=...,done=...}`.

Task options:

- `prio=high|medium|med|low`;
- `author=<text>`;
- `deadline=<value>` or `due=<value>`;
- `late`;
- `completed`.

Task declarations use `\kanbantask[<options>]{<column>}{<text>}`. When its
name is available, `\kbtask` is an exact concise alias with the same signature
and behavior. A pre-existing `\kbtask` definition is preserved and produces a
package warning; the canonical `\kanbantask` command remains available.

Mode, date-format, and priority values are trimmed and compared without regard
to letter case. Palette names are case-sensitive. `columnsep` must be a
non-negative explicit TeX dimension or a single registered dimension.

The package deliberately defines no generic `\task` shorthand. The explicit
`\kanbantask` command and namespaced `\kbtask` alias avoid claiming a name used
by document classes and other packages.

The complete user manual is generated from `kanban.dtx` as `kanban.pdf`.

## Default columns

If a `kanban` environment has no `columns` option, it uses the current
document-wide column list. The built-in list is `BACKLOG,DOING,DONE`, so a
complete board can begin simply with:

```latex
\begin{kanban}
  \kanbantask{Backlog}{Collect the request}
  \kanbantask{Doing}{Prepare the response}
  \kanbantask{Done}{Record the outcome}
\end{kanban}
```

Set different initial defaults while loading the package:

```latex
\usepackage[columns={Planned,Active,Complete}]{kanban}
```

or change them for all later boards:

```latex
\kanbansetup{columns={Queued,Processing,Stored}}
```

The extra braces around the value protect its comma-separated list. An empty
document-level `columns` value is rejected and leaves the preceding default
unchanged. At board level, omitting `columns` or writing `columns={}` uses the
current default. A non-empty board value remains local to one board:

```latex
\begin{kanban}[columns={Requested,Approved,Rejected}]
  ...
\end{kanban}
```

Every declared name is trimmed and converted to uppercase for display and
lookup. Consequently, `ColName`, `colname`, `Colname`, and `COLNAME` refer to
the same column. Names must remain unique after this conversion; case-only
duplicates produce a package error. If compilation continues, the first
normalized occurrence is retained and later occurrences are ignored.

## Column assignment diagnostics

The column argument of `\kanbantask` is mandatory and is matched
without regard to letter case:

```latex
\begin{kanban}[columns={Research,Review}]
  \kanbantask{research}{Collect the evidence}
  \kanbantask{ReSeArCh}{Document the method}
\end{kanban}
```

Both cards are placed under the displayed `RESEARCH` heading. An empty target
or a name that is not present in the board produces a package error containing
the valid normalized column list:

```latex
\kanbantask{}{A task without a target}
\kanbantask{Archive}{A task for an undeclared stage}
```

Invalid tasks are ignored and do not affect card counts. A task issued outside
a `kanban` environment also produces a direct package error rather than
modifying data left by an earlier board. These checks keep the remaining board
state internally consistent when compilation continues after an error.
Nested `kanban` environments are not supported. The nested environment emits
one package error and ignores its task declarations without producing a
cascade of secondary errors; close the active board before beginning another
one.

## Deadline and due chips

`deadline=<value>` and `due=<value>` are exact aliases. Their spelling does
not affect the appearance of the chip; its status determines the color:

- red indicates a past deadline or a value marked explicitly with `late`;
- amber indicates the current calendar day or current project month;
- neutral gray indicates a future value, an invalid numeric value retained for
  display, or a label without automatic date classification.

The following example uses calendar dates for all three states and fixes its
reference date so that the rendered colors are reproducible.

```latex
\begin{kanban}[
  columns={Overdue,Due now,Upcoming},
  reference-date=2026-07-18
]
  \kanbantask[deadline=01/01/2000]
    {Overdue}{Resolve the review comments}
  \kanbantask[due=07/18/2026]
    {Due now}{Complete the current milestone}
  \kanbantask[deadline=12/31/2099]
    {Upcoming}{Prepare the next milestone}
\end{kanban}
```

Automatic classification uses exact input forms. A calendar date may use US or
English year-last slash notation, German dot notation, ISO hyphen notation, or
slash-separated year-first notation. Years from 1 to 9999, Gregorian month
lengths, and leap years are checked. A project month must have the complete
form `M` followed by an integer from 1 to 999999.
This explicit bound prevents
malformed labels from entering TeX's integer arithmetic. Every other value,
including descriptive
labels beginning with `M` or containing punctuation, remains neutral unless
the task also has the `late` option. A numeric value that has calendar-date or
project-month syntax but lies outside the valid range remains neutral and
generates a warning. Invalid project start dates likewise generate a warning
and do not replace the current valid setting. The project-month prefix is the
uppercase, case-sensitive letter `M`; a lowercase value is an ordinary label.

Project-month boundaries normally use the start-day number. In a month that
does not contain that day, the boundary is clamped to the final valid day. A
project beginning on 31 January therefore enters `M2` on 28 February, or on
29 February in a leap year, and uses 31 March as the following boundary.

## Date formats

The `date-format` key controls the printed representation of every validated
calendar date. US notation is the initial default.

| Key | Component order | Example for 18 July 2026 |
| --- | --- | --- |
| `us` | month/day/year | `07/18/2026` |
| `english` | day/month/year | `18/07/2026` |
| `german` | day.month.year | `18.07.2026` |
| `iso` | year-month-day | `2026-07-18` |
| `ymd` | year/month/day | `2026/07/18` |

Select the initial default as a package option, revise it for subsequent
boards with `\kbset`, or override it locally:

```latex
\usepackage[date-format=english]{kanban}
\kbset{date-format=german}

\begin{kanban}[date-format=iso]
  ...
\end{kanban}
```

The spelling `dateformat` is an exact alias; `date-format` is the canonical
public spelling. Format names are trimmed and case-insensitive. New documents
should use the five canonical values in the table. The accepted compatibility
aliases are `american` for `us`; `uk` and `british` for `english`; `de` and
`deutsch` for `german`; and `year-first` for `ymd`.

Unambiguous input in any supported notation is accepted and normalized for
display. A year-last slash date whose first two components are both at most 12
is inherently ambiguous. The `english` and `german` selections interpret it
as day/month/year; `us`, `iso`, and `ymd` interpret it as month/day/year. If
only one interpretation is a valid Gregorian date, that interpretation is
used. ISO input is recommended when dates move between documents because its
order is unambiguous. Project-month values such as `M2` and descriptive labels
are not reformatted.

Project start dates and reference dates are expanded, validated, and stored in
canonical ISO form after their complete package, setup, or board key list has
resolved `date-format`. They are therefore immutable snapshots. A later macro
redefinition or board-local display-format change cannot reinterpret an
inherited date. Task deadlines remain board data and are interpreted under the
board's selected format when cards are rendered.

## Color palettes

The built-in palettes are `default`, `muted`, and `monochrome`. Select the
initial document palette as a package option:

```latex
\usepackage[palette=muted]{kanban}
```

Define and select a custom palette with:

```latex
\kanbandefinepalette{corporate}{
  blue!75!black,
  teal!70!black,
  orange!85!black
}
\kanbansetup{palette=corporate}
```

The unstarred definition uses white heading text. When a palette includes
lighter backgrounds, use the starred form to pair every heading background
with an explicit text color:

```latex
\definecolor{facultyNavy}{HTML}{244A6C}
\definecolor{facultyGold}{HTML}{C69A32}
\definecolor{facultyBerry}{HTML}{843D60}
\kanbandefinepalette*{faculty}{
  facultyNavy/white,
  facultyGold/kanbanInk,
  facultyBerry/white
}
```

Each starred entry must contain exactly one slash and two non-empty `xcolor`
expressions. A malformed list is rejected as one definition. The package does
not calculate a contrast ratio for arbitrary document colors; the explicit
foreground is a control for the author, who remains responsible for readable
contrast.

Palette definitions are document-wide registry operations. Package options,
`\kbset`, and board-local `palette` keys select an already defined palette;
they do not create a board-local palette definition.

When their names are available, the concise commands `\kbtask`, `\kbset`, and
`\kbdefinepalette` are exact aliases of `\kanbantask`, `\kanbansetup`, and
`\kanbandefinepalette`, respectively. A pre-existing short command is preserved
and produces a package warning; the canonical long command remains available.

Palettes may contain any positive number of `xcolor` colors or expressions.
Surrounding spaces in palette names are ignored, but names are case-sensitive.
The colors repeat cyclically when a board has more columns than palette entries.
Every built-in heading color provides a contrast ratio of at least 4.5:1 with
its white text. Custom palettes should preserve comparable contrast, using the
starred definition when different entries require different foregrounds.
Redefining the currently selected palette immediately updates the default for
later boards. A board already in progress retains the palette snapshot taken
when its environment began.
See `kanban-palette-example.tex` for a complete custom-palette document and a
board that demonstrates cyclic reuse.

## Column geometry

Task cards occupy the complete available width of their column body. The
`columnsep` key controls the horizontal distance between adjacent columns. It
accepts a non-negative explicit dimension such as `2mm` or `0.5em`, or a
single registered dimension such as `\linewidth`. Its default value is `2mm`,
and the same value is used for fixed and page-breakable boards. Malformed and
negative values are rejected with one package warning and leave the preceding
default or board-local value unchanged; malformed input is intercepted before
TeX emits secondary number or unit errors.
For `n` columns, the product of `n-1` and `columnsep` must also be smaller than
the available `\linewidth`. If the combined gaps leave no positive column
width, the package reports an error and uses `0pt` for that board without
changing the document default.

In the fixed layout, every heading uses the height of the tallest heading and
every column extends to the height of the tallest column. This includes empty
columns. The column body is transparent; its frame retains the bottom rule but
has no left or right rules. Task cards keep their mode-specific background.
The complete fixed raster is indivisible, so its heading and body rows cannot
be separated by a page break. If insufficient vertical space remains, the
whole board moves to the following page. Use the `break` layout when the board
itself may be taller than one page.
Compile the document twice after changing headings or task lists so the
equal-height measurements can be updated. Page-breakable boards synchronize
their initial headings but keep independent body heights to preserve page
breaking. Headers are not repeated on continuation pages; the supported
`paracol` interface provides independent column streams rather than a repeating
per-column heading row.

Set the initial value as a package option:

```latex
\usepackage[columnsep=3mm]{kanban}
```

Change the default for subsequent boards with:

```latex
\kbset{columnsep=1.5mm}
```

Or override it for one board only:

```latex
\begin{kanban}[columns={Todo,Doing,Done},columnsep=4mm]
  ...
\end{kanban}
```

## Project start date

The project start date follows the same configuration hierarchy as palettes.
Any supported calendar notation is accepted and validated. Ambiguous slash
dates follow the current `date-format` policy.
It may be set when loading the package:

```latex
\usepackage[startdate=07/01/2026]{kanban}
```

changed for subsequent boards:

```latex
\kbset{startdate=07/15/2026}
```

or overridden for one board:

```latex
\begin{kanban}[columns={Todo,Doing,Done},startdate=08/01/2026]
  ...
\end{kanban}
```

Use `\kbset{startdate={}}` to clear the persistent start date for subsequent
boards. A board-local `startdate={}` disables an inherited start date for that
board only and does not change the document default.

Accepted start dates are stored canonically. For example, a start date entered
as US `07/08/2026` remains 8 July on a board that selects English date output;
the display setting cannot change project-month boundaries.

## Reproducible reference date

By default, deadlines are compared with the TeX compilation date. Set
`reference-date` when a rebuild must preserve the same status colors:

```latex
\usepackage[reference-date=2026-07-18]{kanban}
\kbset{reference-date=2026-08-01}

\begin{kanban}[reference-date=2026-08-15]
  ...
\end{kanban}
```

The exact alias `today` is accepted at the same three levels. An empty setup
value restores the compilation date for subsequent boards, and an empty
board-local value restores it for that board only. Reference dates use the
same Gregorian validation and canonical snapshot semantics as project start
dates. Invalid values warn and preserve the preceding setting.

## Light and dark modes

Light mode is the default and uses dark text on light cards. Dark mode switches
the card backgrounds, card text, and borders while retaining the selected
column palette. Author chips and neutral `deadline` or `due` chips intentionally
keep their light-theme background and text colors in both modes. Red overdue
chips and amber due-now chips retain their semantic colors. Column bodies
remain transparent in both modes. Mode selection does not alter the page color
or surrounding document text.

```latex
\usepackage[mode=dark]{kanban} % initial default
\kbset{mode=light}             % subsequent boards

\begin{kanban}[columns={Todo,Doing,Done},mode=dark] % this board only
  ...
\end{kanban}
```

## Semantic labels and style hooks

The labels printed in priority and completion chips can be changed through the
same configuration hierarchy as the other board settings. The accepted nested
keys are `high`, `medium`, `low`, and `done`:

```latex
\usepackage[
  labels={high=URGENT,medium=NORMAL,low=ROUTINE,done=FINISHED}
]{kanban}

\kbset{labels={done=APPROVED}} % subsequent boards

\begin{kanban}[labels={high=IMMEDIATE}] % this board only
  ...
\end{kanban}
```

Omitted labels keep their current values. Empty labels are rejected with a
warning. A board retains the four labels that were active when its environment
began.

Namespaced `tcolorbox` styles provide a stable extension point for presentation
changes. They are applied after the package's structural defaults:

```latex
\tcbset{
  kanban/header/.append style={fontupper=\bfseries\sffamily},
  kanban/card/.append style={arc=1mm,outer arc=1mm},
  kanban/author-chip/.append style={left=1.5mm,right=1.5mm}
}
```

The complete public style set is `kanban/header`, `kanban/card`,
`kanban/column-body`, `kanban/priority-chip`, `kanban/author-chip`,
`kanban/deadline-chip`, and `kanban/completed-chip`. These settings are
document-wide. The header, card, and chip styles affect both renderers;
`kanban/column-body` affects only the fixed renderer because a page-breakable
`paracol` stream has no enclosing body box. Keep `width=\linewidth` on cards
and verify altered padding in narrow columns. The semantic colors
`kanbanHigh`, `kanbanMed`, and `kanbanLow`
may also be redefined, but custom foreground and background pairs should retain
readable contrast. The supplied red and green chips use white text, whereas the
lighter orange chip uses dark ink.

## Combined usage example

Package options provide shared defaults for every board in a document:

```latex
\documentclass{article}
\usepackage[
  columns={Planned,Active,Complete},
  palette=muted,
  mode=light,
  date-format=us,
  startdate=07/01/2026,
  reference-date=2026-07-18,
  columnsep=2mm
]{kanban}

\begin{document}

\begin{kanban}
  \kanbantask[prio=high,author=Alice,due=M1]
    {Planned}{Validate the data set}
  \kanbantask[author=Bob,due=M2]
    {Active}{Draft the results section}
  \kanbantask[completed]
    {Complete}{Approve the analysis plan}
\end{kanban}

% This override applies only to the following board.
\begin{kanban}[
  columns={Queued,Stored},
  mode=dark,
  palette=monochrome
]
  \kanbantask{Queued}{Deposit the source data}
  \kanbantask[completed]{Stored}{Create the archive record}
\end{kanban}

\end{document}
```

Use `break` when a board contains enough cards to continue onto another page:

```latex
\begin{kanban}[columns={Backlog,In progress,Review,Done},break]
  ...
\end{kanban}
```

## Additional examples

The release includes focused, self-contained examples that can be copied and
adapted directly (kept in the `examples/` directory of the repository):

Every date-bearing example fixes `reference-date=2026-07-18`, so its semantic
chip colors remain identical when the example is rebuilt later.

- `kanban-modes-example.tex` places a light and a dark board in the same
  document;
- `kanban-deadlines-example.tex` compares overdue, current, and future
  deadline chips on light and dark cards;
- `kanban-date-formats-example.tex` renders one ISO input date in all five
  available output conventions;
- `kanban-palette-example.tex` defines and applies a three-color custom
  palette;
- `kanban-columnsep-example.tex` demonstrates the package option, `\kbset`,
  and board-local forms of `columnsep`;
- `kanban-break-example.tex` contains enough cards to demonstrate a board
  continuing onto a later page;
- `kanban-landscape-example.tex` places a populated six-column fixed board in a
  `pdflscape` `landscape` environment and uses short, one-line stage names.

The user manual presents both the relevant source fragments and their rendered
output, including the three deadline colors, a custom palette, an actual page
transition, and a dedicated rotated page. The remaining standalone examples
also include representative `deadline` and `due` declarations.

A landscape board must use the fixed layout. Do not combine the `break` option
with a `pdflscape` `landscape` environment; the page-breaking layout is not
compatible with that use. The complete fixed board must fit on the landscape
page. `pdflscape` is required only by the landscape example and is not a
dependency of the `kanban` package itself.

For six-column landscape boards, concise stage names preserve useful card
width. The supplied example uses `Build` and `Docs` for implementation and
documentation and places three tasks in every stage. Page margins and
`columnsep` should be adjusted before card text is shortened; unfamiliar
abbreviations should be explained in the surrounding document.

Compile fixed boards twice after changing headings or task lists so the stored
equal-height measurements are updated.

## Requirements

The package requires LaTeX 2020-10-01 or later and the packages `xcolor`,
`etoolbox`, `tikz`, `tcolorbox`, and `paracol`. The regression suite is run
with pdfTeX, LuaTeX, and XeTeX. Continuous integration tests both a current
TeX Live installation and an actual TeX Live 2020 installation. The local
compatibility test additionally selects the declared format boundary through
LaTeX's official `latexrelease` mechanism.

## Reporting problems

Please include a minimal complete document, the relevant log output, and the
versions of LaTeX and `kanban` when reporting a defect. Package information is
published at <https://ctan.org/pkg/kanban>. Development takes place in the
[public repository](https://www.github.com/andreaswillibaldweber/ctan-kanban),
and defects or focused enhancement proposals should be submitted through its
[issue tracker](https://www.github.com/andreaswillibaldweber/ctan-kanban/issues).
The contribution procedure and required verification commands are described
in `CONTRIBUTING.md`. Maintainer release preparation is documented separately
in `RELEASING.md`.

## License

This work is distributed under the LaTeX Project Public License, version 1.3c
or later. It has LPPL maintenance status `maintained`; the Current Maintainer
is Andreas Willibald Weber.
