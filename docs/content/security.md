---
sidebar_position: 6
---

# Security model

## Keep the key in Roblox Secret Store

The SDK obtains the ingestion key with `HttpService:GetSecret()` during server initialization. It sends the key only in the `x-raiblax-key` header of the handshake request, then keeps the returned session token solely in server memory. Event ingestion uses `Authorization: Bearer <sessionToken>`.

The key is never:

- written into source code;
- logged by the SDK;
- included in an analytics payload;
- available to LocalScripts;
- placed in `ReplicatedStorage`.

The session token follows the same rules. The SDK refreshes it before its 15-minute expiry and obtains a fresh one after an ingestion `401`.

## Use a scoped ingestion key

Create a key per game and restrict it to event ingestion. It must not grant administrative access to the Raiblax workspace. Rotate or revoke the key from the Raiblax web application if it is no longer needed.

## Server-only transport

Only server scripts call Raiblax over HTTP. When client interaction tracking is added, LocalScripts will send events through a server-owned `RemoteEvent`; the server will validate and rate-limit them before delivery.
