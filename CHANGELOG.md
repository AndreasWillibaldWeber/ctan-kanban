# Changelog

## 1.0.0 - 2026-07-18

Initial public release.

- Provide a key-based `kanban` environment with built-in
  `BACKLOG,DOING,DONE` columns and board-local column overrides.
- Normalize column names for case-insensitive task assignment, while mapping
  user-facing names to isolated numeric internal identifiers.
- Collect tasks safely across ordinary TeX groups, clean temporary board data
  after rendering, and reject nested boards with an actionable diagnostic.
- Provide `\kanbantask` with priority, author, deadline, explicit overdue, and
  completion metadata, together with the collision-tolerant `\kbtask` alias;
  deliberately leave the generic `\task` name untouched.
- Classify validated Gregorian dates and positive project-month deadlines at
  compilation time, with document-wide and board-local project start dates.
- Provide US, English, German, ISO, and slash-separated year-first date
  formats at package, setup, and board level; use US output by default and
  normalize validated calendar dates before rendering. Accept documented
  compatibility aliases for the regional format names.
- Store accepted project start dates and fixed reference dates as expanded,
  canonical ISO snapshots so later macro or display-format changes cannot
  alter their semantic date.
- Provide package, setup, and board-local `reference-date` configuration, with
  `today` as an exact key alias, for reproducible calendar and project-month
  classification; retain the TeX compilation date as the default.
- Provide canonical `\kanbansetup` and `\kanbandefinepalette` commands together
  with the concise aliases `\kbset` and `\kbdefinepalette` when those short
  names are available; preserve pre-existing definitions and issue a warning
  on a collision.
- Support named palettes of arbitrary positive length, cyclic color reuse, and
  built-in `default`, `muted`, and `monochrome` palettes.
- Refresh the default for later boards when the currently selected palette is
  redefined, while preserving the snapshot of a board already in progress.
- Support light and dark card modes while keeping author and deadline chips on
  a stable light treatment and preserving semantic overdue and due-now colors.
- Provide fixed equal-height boards with transparent column bodies, full-width
  cards, synchronized headings and bottoms, and configurable column gaps.
- Provide page-breakable `paracol` boards with synchronized headings and
  independent column bodies, plus fixed landscape-board guidance for
  `pdflscape`.
- Report invalid columns, assignments, options, palettes, modes, priorities,
  start dates, and negative column gaps without silently corrupting board data.
- Parse setup, board, task, and semantic-label options through namespaced
  LaTeX3 key families, defer stored dates until each key list has resolved its
  date format, and route new validation diagnostics through named messages.
- Process package options through `kvoptions` on LaTeX formats older than
  2021-06-01, whose native option processor cannot parse brace groups in
  package option lists; newer formats use the brace-aware kernel processor
  directly.
- Validate explicit column-gap dimensions before assignment, accepting fixed
  dimensions and registered dimension values while replacing raw TeX
  number/unit failures with one actionable package warning.
- Reject a combined column gap that leaves no positive board width, recover
  locally with a zero gap, and suppress secondary task errors inside a rejected
  nested board.
- Clamp project-month anniversaries to the final valid day of shorter months
  and bound automatic project-month parsing to `M1` through `M999999`.
- Include documented source, eight standalone examples, a professionally
  typeset manual, `l3build` release configuration, and regression coverage for
  pdfTeX, LuaTeX, and XeTeX.
- Exercise the declared LaTeX 2020-10-01 format boundary with `latexrelease`
  and an actual TeX Live 2020 continuous-integration job, assert core layout
  and pagination invariants, and ship the complete regression suite in the
  CTAN and TDS source archives.
- Add public-behaviour regression cases for canonical and macro-based date
  snapshots, inherited-format stability, reference-date scope and reset,
  metadata aliases and flags, malformed dimensions, macro-based columns, and
  one-column rendering.
- Publish repository contribution guidance, structured issue and pull-request
  templates, build artifacts for visual review, and release-archive integrity
  checks.
- Harmonize the LPPL file manifests and add a reproducible maintainer release
  checklist.
- Improve built-in heading and semantic-chip contrast while preserving stable
  author and deadline styling across light and dark modes.
- Add configurable semantic labels and namespaced public `tcolorbox` style
  hooks for controlled typographic and spacing adjustments.
- Diagnose invalid date-shaped and project-month-shaped deadline values while
  retaining their neutral display as a recoverable result.
- Accept all five supported Gregorian notations for deadlines and project
  start dates through the same validated calendar path, with deterministic
  handling of ambiguous year-last slash dates and explicit clearing of an
  inherited project start date.
- Allow starred palette definitions to pair each custom heading background
  with an explicit foreground color, while preserving the unstarred interface.
- Remove board-local heading, color, list, and counter definitions after each
  completed board and document the non-repeating continuation-header behavior
  of the supported page-breakable renderer.
