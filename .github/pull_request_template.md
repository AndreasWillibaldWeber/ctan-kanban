## Purpose

Describe the user-visible or maintainer-visible improvement and link the issue
that motivates it.

## Verification

- [ ] `l3build check` passes with pdfTeX, LuaTeX, and XeTeX.
- [ ] `l3build doc` completes without fatal diagnostics or overfull boxes.
- [ ] `l3build ctan` completes and the release archive was inspected.
- [ ] New or changed behaviour has regression coverage.
- [ ] Date changes preserve canonical start/reference snapshots and reproducibility.
- [ ] Documentation and `CHANGELOG.md` are consistent with the implementation.
- [ ] Visual changes include before-and-after output for review.

## Compatibility

Describe any effect on documented commands, keys, defaults, diagnostics, or the
declared TeX Live 2020 compatibility boundary.
