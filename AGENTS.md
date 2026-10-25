# Agent Instructions

This repo is a Claude Code plugin marketplace. `plugins/` and `rules/` are
content shipped to other projects – they are not instructions for working on
this repo.

## Commands

- `make check` validates marketplace and plugin manifests and runs Prettier.
- `make fix` formats all files.
- Never run `make deploy` unless asked; it pushes a tag.

## Conventions

- Do not bump `version` in
  `plugins/muspellheim-shared/.claude-plugin/plugin.json` on your own. It is
  bumped only for a planned release and follows Semantic Versioning.
- Keep the "Usage" list in `README.md` in sync with skills, hooks and rules.
- Keep skills and rules language-independent; put language-specific details in a
  skill's `references/` folder.
- Commits follow `rules/commits.md`.
