# Muspellheim Marketplace for Claude

[![Build](https://github.com/falkoschumann/muspellheim-marketplace-claude/actions/workflows/build.yml/badge.svg)](https://github.com/falkoschumann/muspellheim-marketplace-claude/actions/workflows/build.yml)
[![Tag](https://img.shields.io/github/v/tag/falkoschumann/muspellheim-marketplace-claude?sort=semver)](https://github.com/falkoschumann/muspellheim-marketplace-claude/tags)

Plugins for my projects.

## Install

Add marketplace and install plugin:

```terminal
claude plugin marketplace add https://github.com/falkoschumann/muspellheim-marketplace-claude.git
claude plugin install muspellheim-shared
```

Enable and disable plugin:

```terminal
claude plugin disable muspellheim-shared --scope user
claude plugin enable muspellheim-shared --scope project
```

Update plugin:

```terminal
claude plugin marketplace update muspellheim
claude plugin update muspellheim-shared@muspellheim
```

> [!IMPORTANT]
>
> Currently, the rules cannot be packaged into a plugin. Therefore, you have to
> manually copy the `rules` folder into your `.claude` folder or add them to
> your `AGENTS.md`.

## Usage

### Muspellheim Shared

This plugin provides shared hooks and skills for my projects:

- Verify results when a task is finished by running `make check`
- Model a domain with ESDM
- Implement the application slice by slice
- Review the usability and user experience

### Rules

The folder `rules` contains shared rules for my projects:

- Functional core, imperative shell architecture
- Manage a backlog
- Create conventional commits
- Model Domain with [ESDM](https://www.esdm.io)
- Code style for TypeScript
- Test style
- UI/UX Guidelines
