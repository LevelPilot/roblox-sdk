---
sidebar_position: 3
---

# Track an event

Use `track()` to send a meaningful game action.

```lua
local success, errorMessage = Analytics.track("level_completed", {
  levelId = 12,
  durationSeconds = 95,
  difficulty = "normal",
})
```

## Event names

An event name must start with a letter or underscore. It can contain letters, numbers, underscores, periods, and hyphens.

```lua
Analytics.track("tutorial_completed")
Analytics.track("level.completed")
Analytics.track("level-completed")
```

## Properties

Omitted or empty properties are excluded from the JSON payload, allowing the API to default to an empty object instead of receiving a JSON array. Non-empty properties are preserved.

Properties must be JSON-compatible values. Keep their schema stable over time so they can be aggregated reliably.

```lua
Analytics.track("currency_spent", {
  currency = "coins",
  amount = 120,
  source = "shop",
})
```

Raiblax automatically adds `occurredAt`, `gameId`, `placeId`, and `jobId` to every event.

:::caution Keep sensitive data out of events
Do not send keys, tokens, passwords, email addresses, or other personal data in event properties.
:::
