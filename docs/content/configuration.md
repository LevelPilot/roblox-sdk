---
sidebar_position: 5
---

# Configuration

The SDK works with no configuration beyond the secret stored in Roblox. Pass options only when you need to override a default.

```lua
Analytics.init({
  secretName = "MY_RAIBLAX_KEY",
  debug = true,
  autoFlush = false,
})
```

| Option | Default | Description |
| --- | --- | --- |
| `secretName` | `RAIBLAX_API_KEY` | Name of the Roblox Secret Store entry. |
| `endpoint` | `https://api.raiblax.com/v1/events` | HTTPS ingestion endpoint. Use a custom endpoint for staging only. |
| `handshakeEndpoint` | `https://api.raiblax.com/api/v1/sdk/handshake` | HTTPS endpoint that exchanges the Secret Store key for a server-only session token. |
| `allowInsecureHttp` | `false` | Allows `http://localhost:<port>/...` only for local Studio testing. Never enable this for a published experience. |
| `debug` | `false` | Reserved for future non-sensitive diagnostics. |
| `autoFlush` | `true` | Immediately sends every tracked event. Set it to `false` to control delivery with `flush()`. |

## Controlled flushing

```lua
Analytics.init({ autoFlush = false })

Analytics.track("level_started", { levelId = 3 })
Analytics.track("level_completed", { levelId = 3 })

local success, errorMessage = Analytics.flush()
```
