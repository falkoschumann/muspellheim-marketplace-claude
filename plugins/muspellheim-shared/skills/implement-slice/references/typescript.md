# TypeScript

Place the tests and the code in `src/`, unless the project conventions say
otherwise.

## Domain

### Types

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

ESDM names are in kebab-case. Identifiers in code use camelCase and PascalCase,
like `DoSomethingCommand`. The `type` of a message keeps the ESDM name, like
`"do-something"`.

### Result and Rejection

```typescript
type Result<T, E> =
  Readonly<{ ok: true; value: T }> | Readonly<{ ok: false; error: E }>;

function ok<T>(value: T): Result<T, never> {
  return { ok: true, value };
}

function fail<E>(error: E): Result<never, E> {
  return { ok: false, error };
}

type Rejection = Readonly<{
  invariant: string;
}>;
```

### Aggregate and DCB

```typescript
const initialState: State = {
  // ...
};

function consults(command: Command): EventQuery {
  // ...
}

function decide(state: State, command: Command): Result<Event[], Rejection> {
  switch (command.type) {
    // ...
  }
}

function evolve(state: State, event: Event): State {
  switch (event.type) {
    // ...
  }
}

function evolveAll(state: State, events: readonly Event[]): State {
  return events.reduce(evolve, state);
}
```

### Read Model and Query

```typescript
const initialReadModel: ReadModel = {
  // ...
};

function project(readModel: ReadModel, event: Event): ReadModel {
  switch (event.type) {
    // ...
  }
}

function projectAll(readModel: ReadModel, events: readonly Event[]): ReadModel {
  return events.reduce(project, readModel);
}

function getSomething(
  readModel: ReadModel,
  query: GetSomethingQuery,
): GetSomethingQueryResult {
  // ...
}
```

### Process Manager

```typescript
type Trigger = Event | Readonly<{ type: "timer"; timer: TimerName }>;

type Reaction = Readonly<{
  commands: readonly Command[];
  setTimers: readonly TimerName[];
  cancelTimers: readonly TimerName[];
}>;

function evolve(state: State, trigger: Trigger): State {
  // ...
}

function react(state: State, trigger: Trigger): Reaction {
  // ...
}

function isEnded(state: State): boolean {
  // ...
}
```

### Scenario Test

```typescript
describe("Something", () => {
  it("should do something", () => {
    const state = evolveAll(initialState, [
      { type: "something-created", data: { id: 1 } },
    ]);

    const result = decide(state, { type: "do-something", data: { id: 1 } });

    expect(result).toEqual(
      ok([{ type: "something-happened", data: { id: 1 } }]),
    );
  });

  it("should reject something", () => {
    const state = evolveAll(initialState, []);

    const result = decide(state, { type: "do-something", data: { id: 1 } });

    expect(result).toEqual(fail({ invariant: "something-exists" }));
  });
});
```
