# Changelog

The package uses semantic versioning. Each release lists its user-visible
changes here.

## 1.0.0 (2026-11-07)

Initial public release.

- The `kanban` environment with a three-level configuration hierarchy of
  package options, `\kanbansetup`, and board options.
- `\kanbantask` with priority, author, deadline, explicit `late`, and
  `completed` metadata. The concise aliases `\kbtask`, `\kbset`, and
  `\kbdefinepalette` never overwrite an existing command.
- Case-insensitive column lookup. Headings keep the spelling of the column
  list, and the built-in columns are `Backlog`, `Doing`, and `Done`.
- Calendar deadlines in US, English, German, ISO, and year-first notation
  with four-digit years, Gregorian validation, canonical storage, and five
  display formats.
- Project-month deadlines `M1` to `M999999` relative to a validated start
  date, with month-end clamping.
- Fixed reference dates for reproducible classification. The compilation
  date remains the default.
- Fixed equal-height boards and page-breakable `paracol` boards, light and
  dark modes, built-in and custom palettes with optional heading
  foregrounds, a configurable column gap, semantic labels, and namespaced
  `tcolorbox` style hooks.
- Diagnostics with line context for invalid options, dates, dimensions, and
  column assignments. Every diagnostic leaves the board in a consistent
  state.
- Documented source, a user manual, eight standalone examples, and an
  `l3build` regression suite for pdfTeX, LuaTeX, and XeTeX that includes a
  strict run with expl3 declaration and deprecation checking.
