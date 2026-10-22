# TypeScript

Place the tests and the code in `src/`, unless the project conventions say
otherwise.

## Types

Map each ESDM schema to a `type` wrapped in `Readonly<>`:

- `object` → `Readonly<{ … }>`, `array` → `readonly T[]`
- `oneOf` → union, mark the properties of the other alternatives as `?: never`
- `allOf` → intersection
- `enum` or `const` → union of literal types
- `$ref` → the referenced type

```typescript
type DoSomethingCommand = Readonly<{
  type: "do-something";
  data: DoSomethingCommandData;
}>;

type SomethingHappenedEvent = Readonly<{
  type: "something-happened";
  data: SomethingHappenedEventData;
}>;

type GetSomethingQuery = Readonly<{
  type: "get-something";
  parameters: GetSomethingQueryParameters;
}>;

type GetSomethingQueryResult = Readonly<{
  something: Something;
}>;
```

## Aggregate and DCB

```typescript
type Result<T, E> =
  Readonly<{ ok: true; value: T }> | Readonly<{ ok: false; error: E }>;

function ok<T>(value: T): Result<T, never> {
  return { ok: true, value };
}

function fail<E>(error: E): Result<never, E> {
  return { ok: false, error };
}

function decide(state: State, command: Command): Result<Event[], Error> {
  switch (command.type) {
    // ...
  }
}

function evolve(state: State, event: Event): State {
  switch (event.type) {
    // ...
  }
}

function evolveAll(state: State, events: Event[]): State {
  return events.reduce(evolve, state);
}
```

## Read Model and Query

```typescript
function project(readModel: ReadModel, event: Event): ReadModel {
  switch (event.type) {
    // ...
  }
}

function projectAll(readModel: ReadModel, events: Event[]): ReadModel {
  return events.reduce(project, readModel);
}

function getSomething(
  readModel: ReadModel,
  query: GetSomethingQuery,
): GetSomethingQueryResult {
  // ...
}
```
