# Domain Model

The domain model is written with ESDM. Add or update the model, including its
scenarios, before writing tests and code. The skill `model-domain` holds the
modeling conventions.

## Naming of Reacting Building Blocks

Event handlers, policies and process managers react to events. Name them after
the acting instance as a noun with the suffix "-er" or "-or", like
`invoice-sender` or `payment-reminder`, so they never collide with the verb
phrases of commands and queries. They may react to several events and emit
several commands, so a rule form like "notify customer on shipment" does not fit
them.

## References in Schemas

The reference notation of ESDM addresses a building block, not its schema. A
`$ref` in a JSON Schema refers to the shape of the referenced building block:

| Building block       | `$ref` refers to |
| -------------------- | ---------------- |
| entity, value object | `schema`         |
| aggregate            | `state`          |
| read model           | `schema`         |
| command, event       | `data`           |

Reference only building blocks with exactly one shape. A query has two,
`parameters` and `result`, so do not reference a query. When several queries
share a result or a parameter, extract it as a value object.
