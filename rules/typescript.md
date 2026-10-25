---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript

- Define data with `type` wrapped in `Readonly<>` and behavior with `interface`.
  Contracts of the shell like services, gateways and repositories are an
  `interface`.
- Use camelCase for values and functions and PascalCase for types. Keep external
  names, like the type of a message, unchanged.
- Name a test file after the module under test with the suffix `.test.ts` or
  `.test.tsx`.
- Write tests with `describe` for the subject and `it` for the behavior, like
  `describe("Something")` with `it("should do something")`, or in German
  `it("sollte etwas tun")`.
