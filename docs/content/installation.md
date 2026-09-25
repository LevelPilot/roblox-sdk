---
sidebar_position: 2
---

# Install the SDK

## 1. Sync the project with Rojo

Sync this repository with your experience using Rojo. The default project mounts the `RaiblaxAnalytics` module in `ServerScriptService`.

## 2. Create the ingestion secret

In Roblox Creator Hub, open your experience's **Secrets** section and create a secret named:

```text
RAIBLAX_API_KEY
```

Paste the ingestion key generated in the Raiblax web application. This must be an ingestion-only key: it should be scoped to one game and be revocable from Raiblax.

## 3. Enable HTTP requests

In Roblox Studio, open **Game Settings → Security** and turn on **Allow HTTP Requests**.

## 4. Initialize once

Require the module from a server Script and initialize it during your game bootstrap.

```lua
local Analytics = require(game:GetService("ServerScriptService").RaiblaxAnalytics)

Analytics.init()
```

`init()` is intentionally called only once. It uses the production endpoint and looks up `RAIBLAX_API_KEY` automatically.
