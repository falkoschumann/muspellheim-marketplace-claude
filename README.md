# Muspellheim's Claude Marketplace

Plugins for my projects.

## Install

Add marketplace and install plugin:

```terminal
claude plugin marketplace add https://github.com/falkoschumann/claude-plugins
claude plugin install muspellheim-shared
```

Enable and disable plugin:

```terminal
claude plugin disable muspellheim-shared --scope user
claude plugin enable muspellheim-shared --scope project
```

Update marketplace:

```terminal
claude plugin marketplace update muspellheim
```

> [!IMPORTANT]
>
> Currently, the rules cannot be packaged into a plugin. Therefore, you have to
> manually copy the `rules` folder into your `.claude` folder.

## Usage

- **Muspellheim Shared:** Shared hooks and skills for my projects:
  - Verify results after a task
  - Model a domain
  - Implement a feature
  - Review the usability and user experience
- **Rules**
  - Functional core, imperative shell archiecture
  - Manage a backlog
  - Create conventional commits
  - Model Domain with [ESDM](https://www.esdm.io)
  - Code style for TypeScript
  - Test style for TypeScript
  - UI/UX Guidelines
