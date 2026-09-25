# Raiblax Analytics SDK for Roblox

This server-only Luau SDK sends analytics events from a Roblox experience to the Raiblax ingestion API.

## Install

1. Sync this repository with your experience using Rojo. The `RaiblaxAnalytics` module is placed in `ServerScriptService`.
2. Enable **Allow HTTP Requests** in **Game Settings > Security**.
3. In the Roblox Creator Hub, add your Raiblax ingestion key to the experience Secret Store using the name `RAIBLAX_API_KEY`.
4. Require and initialize the module from a server `Script`.

```lua
local ServerScriptService = game:GetService("ServerScriptService")
local Analytics = require(ServerScriptService.RaiblaxAnalytics)

local initialized = Analytics.init()
if not initialized then
	return
end

local success, errorMessage = Analytics.track("sdk_test", {
	 source = "roblox-studio",
})

if not success then
	 warn("Raiblax event was not delivered: " .. (errorMessage or "unknown error"))
end
```

At initialization, the SDK reads the key with `HttpService:GetSecret()` and exchanges it for an in-memory session token through `POST /api/v1/sdk/handshake`. Event ingestion uses only `Authorization: Bearer <sessionToken>`. The SDK refreshes the session before its 15-minute lifetime ends and retries an event once after an ingestion `401`.

Neither the key nor the session token is logged, replicated, or exposed to client code.

## Configuration

Only the secret is required. Advanced options remain optional:

```lua
Analytics.init({
	secretName = "MY_RAIBLAX_KEY",
	endpoint = "https://api.raiblax.com/v1/events",
	handshakeEndpoint = "https://api.raiblax.com/api/v1/sdk/handshake",
	allowInsecureHttp = false,
	debug = true,
	autoFlush = true,
})
```

`autoFlush` defaults to `true` for the initial integration test. Later SDK versions can change the internal delivery strategy to batching and retries without changing `track()`.

## Public API

- `Analytics.init(options?)`: Reads the configured Secret Store entry and completes the server-only handshake. Returns `false` when the key is unavailable or the handshake fails.
- `Analytics.track(eventName, properties?)`: Queues an event and, by default, sends it immediately.
- `Analytics.flush()`: Sends all queued events. Failed events remain queued.
- `Analytics.getPendingEventCount()`: Returns the number of events still queued.
- `Analytics.getLastInitializationError()`: Returns a non-sensitive initialization diagnostic for server-side troubleshooting.

## Event payload

Each event is delivered as JSON with `eventName`, `occurredAt`, `properties`, and an automatic `context` containing `gameId`, `placeId`, and `jobId`.

## Security notes

Use a server script only. Do not place the module, a key, or a generated configuration file in `ReplicatedStorage`. The Raiblax key should be an ingestion-only key that can be revoked and rotated in the Raiblax web application.
