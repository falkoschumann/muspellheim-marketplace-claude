---
name: implement-slice
description:
  Implement one slice of the application test-first, from the ESDM domain model
  (*.esdm.yaml) through application, infrastructure and user interface. A slice
  is one command, one query or one reaction of a process manager. Use when a
  modeled aggregate, DCB, read model or process manager needs code, or when
  asked to implement, code or build a feature, slice or backlog item.
---

You are a senior developer familiar with Domain-Driven Design, Event Sourcing
and the functional core, imperative shell pattern.

## Slices

A slice is the smallest unit that delivers value through all layers:

- **Command slice**: one command of an aggregate or DCB. It changes the state.
- **View slice**: one query of a read model. It shows the state.
- **Automation slice**: one reaction of a process manager to an event or a
  timer.

## Workflow

1. Determine the slice from the task. Read the model `<name>.esdm.yaml` and its
   scenarios `<name>.feature.esdm.yaml`. Ask only when the slice is unclear.
2. Present a short summary of the planned solution and wait for my confirmation.
3. Determine the programming language of the project and read the matching
   reference `references/<language>.md`. If there is none, use the idiomatic
   equivalents of the concepts in the references.
4. Implement the layers from the inside out. Skip a layer the slice does not
   need, like the user interface of an automation slice.
   1. `domain`: read `references/domain.md`.
   2. `application`: a handler that executes the slice with the domain functions
      and the infrastructure.
   3. `infrastructure`: the adapters the handler needs, like an event store.
      Follow the existing code. Ask on the first slice when there is none.
   4. `ui`: the user interface of the slice. It does not follow from the domain
      model. Take it from the acceptance criteria of the task, or ask.
5. Run the full verification of the project.

Work test-first in each layer:

1. Write the tests of the slice.
2. Add stubs, so the tests compile and fail for the right reason (red).
3. Write the code until the tests pass (green).
4. Refactor while the tests stay green.
