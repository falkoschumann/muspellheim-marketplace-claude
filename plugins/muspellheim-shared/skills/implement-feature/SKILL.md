---
name: implement-feature
description:
  Implement a feature from the ESDM domain model (*.esdm.yaml) test-first. Turn
  the Given-When-Then scenarios of the matching *.feature.esdm.yaml into failing
  tests, then write the code. Use when an aggregate, DCB, read model or process
  manager is modeled and needs code, or when asked to implement, code or build a
  feature or backlog item.
---

You are a senior full-stack developer and familiar with domain driven design and
the functional core, imperative shell pattern.

1. Ask which specification shall be implemented.
2. Read the specification from a file `<name>.esdm.yaml`.
3. Locate the appropriate test cases from a file `<name>.feature.esdm.yaml`.
4. Determine the programming language of the project and read the matching
   reference `references/<language>.md`. If there is none, use the idiomatic
   equivalents of the concepts below.
5. Write the tests where the project conventions place them.
6. Run the tests and ensure they fail (show red).
7. Write the code where the project conventions place it.
8. Iterate until all tests pass (show green).

## Domain Code

The domain code must be pure functional without I/O. All data is immutable.

Commands and Events have a `type` and a `data` property. Queries have a `type`
and a `parameters` property. The `type` is the name and `data`/`parameters` is
the payload, from their ESDM definition. The `type` discriminates the variants
of a message union.

### Types

Map each ESDM schema to an immutable type:

- `object` → immutable record
- `array` → immutable list
- `oneOf` → sum type (tagged union) of the alternatives
- `allOf` → composition of the parts
- `enum` or `const` → closed set of literal values
- `$ref` → the referenced type

```
type DoSomethingCommand = { type: "do-something", data: DoSomethingCommandData }
type SomethingHappenedEvent = { type: "something-happened", data: SomethingHappenedEventData }
type GetSomethingQuery = { type: "get-something", parameters: GetSomethingQueryParameters }
type GetSomethingQueryResult = { something: Something }
```

### Aggregate and DCB

- `decide(state, command) → Result<Event[], Error>` – verifies the invariants
  (business rules) and decides which events to publish or reject.
- `evolve(state, event) → State` – applies an event to the state (reducer).

`Result` is either a success with a value or a failure with an error.

```
decide(state, command) → Result<Event[], Error>
  match command.type
    case ... → ok([events]) or fail(error)

evolve(state, event) → State
  match event.type
    case ... → new state

evolveAll(state, events) → State
  fold events with evolve starting at state
```

### Read Model and Query

- `project(readModel, event) → ReadModel` – applies an event to the read model
  (reducer).
- `<query>(readModel, query) → QueryResult` – answers a query from the read
  model.

```
project(readModel, event) → ReadModel
  match event.type
    case ... → new read model

projectAll(readModel, events) → ReadModel
  fold events with project starting at readModel

getSomething(readModel, query: GetSomethingQuery) → GetSomethingQueryResult
```
