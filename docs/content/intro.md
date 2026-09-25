---
sidebar_position: 1
slug: /
---

# Roblox analytics, without exposing a key

Raiblax Analytics is a server-side Luau SDK that sends game events to your Raiblax workspace. The client never receives the ingestion key.

## What you need

- A Roblox experience connected to Raiblax.
- Rojo to sync this SDK into `ServerScriptService`.
- HTTP requests enabled in **Game Settings → Security**.
- A Raiblax ingestion key stored in the Roblox Secret Store as `RAIBLAX_API_KEY`.

## First event

```lua
local ServerScriptService = game:GetService("ServerScriptService")
local Analytics = require(ServerScriptService.RaiblaxAnalytics)

Analytics.init()

local success, errorMessage = Analytics.track("sdk_test", {
  source = "roblox-studio",
})

if not success then
  warn("Raiblax event was not delivered: " .. (errorMessage or "unknown error"))
end
```

Use `sdk_test` to verify your connection before instrumenting a game flow. Continue with [installation](./installation) for the complete setup.

:::tip Server-only by design
Call the SDK from a Script in `ServerScriptService`. Client-originated events will be supported through a validated server relay in a later version.
:::
