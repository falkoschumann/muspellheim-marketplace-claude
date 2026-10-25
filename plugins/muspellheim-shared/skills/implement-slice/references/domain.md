# Domain

The domain code is pure functional without I/O. All data is immutable. Pass the
current time, random values and generated identities in as data.

## Types

Commands and events have a `type` and a `data` property. Queries have a `type`
and a `parameters` property. The `type` is the name and `data`/`parameters` is
the payload, from their ESDM definition. The `type` discriminates the variants
of a message union.

Map each ESDM schema to an immutable type:

- `object` → immutable record
- `array` → immutable list
- `oneOf` → sum type (tagged union) of the alternatives
- `allOf` → composition of the parts
- `enum` or `const` → closed set of literal values
- `$ref` → the referenced type

```plaintext
type DoSomethingCommand = { type: "do-something", data: DoSomethingCommandData }
type SomethingHappenedEvent = { type: "something-happened", data: SomethingHappenedEventData }
type GetSomethingQuery = { type: "get-something", parameters: GetSomethingQueryParameters }
type GetSomethingQueryResult = { something: Something }
```

## Result and Rejection

`Result` is either a success with a value or a failure with an error. A
`Rejection` names the violated invariant from the model. The user interface
turns it into a message for the user.

```plaintext
Result<T, E> = ok(value: T) | fail(error: E)
Rejection = { invariant: InvariantName }
```

## Value Object and Entity

An invariant of a value object or entity needs only the data of the value
itself. A constructor function verifies it.

```plaintext
createSomething(data) → Result<Something, Rejection>
```

## Aggregate and DCB

- `initialState` – the state before any event.
- `decide(state, command) → Result<Event[], Rejection>` – verifies the
  invariants and decides which events to publish or rejects the command.
- `evolve(state, event) → State` – applies an event to the state.
- `consults(command) → EventQuery` – DCB only: the event types and tags the
  decision needs.

```plaintext
decide(state, command) → Result<Event[], Rejection>
  match command.type
    case ... → ok([events]) or fail({ invariant })

evolve(state, event) → State
  match event.type
    case ... → new state

evolveAll(state, events) → State
  fold events with evolve starting at state
```

## Read Model and Query

- `initialReadModel` – the read model before any event.
- `project(readModel, event) → ReadModel` – applies an event to the read model.
- `<query>(readModel, query) → QueryResult` – answers a query from the read
  model.

```plaintext
project(readModel, event) → ReadModel
  match event.type
    case ... → new read model

projectAll(readModel, events) → ReadModel
  fold events with project starting at readModel

getSomething(readModel, query: GetSomethingQuery) → GetSomethingQueryResult
```

## Process Manager

A trigger is an incoming event or a fired timer.

- `initialState` – the state of a new instance.
- `evolve(state, trigger) → State` – applies a trigger to the instance state.
- `react(state, trigger) → Reaction` – decides the commands to emit and the
  timers to set or cancel, based on the state before the trigger.
- `isEnded(state) → boolean` – whether the instance is retired.

```plaintext
Reaction = { commands: Command[], setTimers: TimerName[], cancelTimers: TimerName[] }
```

## Scenarios to Tests

Write one test for each scenario of the feature file and name it after the
scenario. Take over the data of the scenario literally. Compare the outcome as a
whole value, not field by field.

Aggregate and DCB:

- Given → `state = evolveAll(initialState, given)`
- When → `result = decide(state, command)`
- Then `events` → `result` is `ok(events)`; an empty list means the command was
  idempotent
- Then `rejection` → `result` is `fail({ invariant })`

Read model:

- Given → `readModel = projectAll(initialReadModel, given)`
- When → `result = <query>(readModel, query)`
- Then `result` → `result` equals the expected result
- Then `readModel` → `readModel` equals the expected read model, the query is
  not called

Process manager:

- Given → `state = evolveAll(initialState, given)`
- When → `reaction = react(state, trigger)` and
  `nextState = evolve(state, trigger)`
- Then `emits`, `setTimers`, `cancelTimers` → the fields of `reaction`, missing
  fields are empty
- Then `state` → `nextState` equals the expected state
- Then `ended` → `isEnded(nextState)` is true

Write unit tests for each invariant of a value object or entity, with a valid
and an invalid value.
