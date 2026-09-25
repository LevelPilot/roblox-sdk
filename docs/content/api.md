---
sidebar_position: 4
---

# Public API

## `Analytics.init(options?)`

Initializes the SDK exactly once.

```lua
Analytics.init()
```

Returns `true` when the configuration is valid, the configured Secret Store entry is available, and the server-only handshake succeeds. The handshake includes the SDK version, place ID, server job ID (or a Studio fallback), and a unique nonce. If the key is missing, unavailable, or the handshake fails, it returns `false`. Calling it more than once after a successful initialization raises an error.

## `Analytics.track(eventName, properties?)`

Queues an event and immediately attempts delivery by default.

```lua
local success, errorMessage = Analytics.track("tutorial_started", {
  tutorialVersion = "v1",
})
```

Returns `true` on success. On failure, it returns `false` and a diagnostic error string. The event remains queued for a later `flush()` call.

## `Analytics.flush()`

Delivers queued events in order.

```lua
local success, errorMessage = Analytics.flush()
```

Delivery stops at the first failed request; unsent events are retained in the local queue.

## `Analytics.getPendingEventCount()`

Returns the number of events currently waiting to be delivered.

```lua
local pendingEvents = Analytics.getPendingEventCount()
```

## `Analytics.getLastInitializationError()`

Returns the latest non-sensitive reason why initialization failed, such as `secret_unavailable`, `handshake_request_failed`, `handshake_rejected_status_401`, or `invalid_handshake_response_session_token`. It never includes a key, session token, or response body.
