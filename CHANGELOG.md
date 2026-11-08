# Changelog

The package uses semantic versioning. Each release lists its user-visible
changes here.

## 1.0.0 (2026-11-07)

Initial public release.

- The `kanban` environment with a three-level configuration hierarchy of
  package options, `\kanbansetup`, and board options.
- `\kanbantask` with priority, author, deadline, explicit `late`, and
  `completed` metadata. Card text may contain robust commands and paragraph
  breaks. The concise aliases `\kbtask`, `\kbset`, and `\kbdefinepalette`
  never overwrite an existing command.
- Column lookup by the purified uppercase text of the name, so letter case,
  formatting commands, and braces do not distinguish columns. Headings keep
  the spelling of the column list, and the built-in columns are `Backlog`,
  `Doing`, and `Done`.
- Calendar deadlines in US, English, German, ISO, and year-first notation
  with four-digit years, Gregorian validation, canonical storage, and five
  display formats.
- Project-month deadlines `M1` to `M999999`, with leading zeros permitted,
  relative to a validated start date, with month-end clamping.
- Fixed reference dates for reproducible classification. The compilation
  date remains the default.
- Fixed equal-height boards and page-breakable `paracol` boards, light and
  dark modes, built-in and custom palettes with optional heading
  foregrounds, semantic labels, and namespaced `tcolorbox` style hooks.
- A column gap given as an explicit dimension, a LaTeX length register, or
  a TeX length parameter such as `\parindent`.
- Named `l3msg` warnings with line context for unknown options and values,
  invalid dates, dimensions, palettes, labels, and deadlines, and package
  errors for invalid column assignments. A robust command in a deadline is
  a neutral label, and a robust command in a dimension or choice value is
  rejected. Diagnostics raised by package options name the package options
  instead of a line. Every diagnostic leaves the board in a consistent
  state, and every message can be redirected with `\msg_redirect_name:nnn`.
- Documented source, a user manual, eight standalone examples, and an
  `l3build` regression suite for pdfTeX, LuaTeX, and XeTeX that includes a
  strict run with expl3 declaration and deprecation checking.
