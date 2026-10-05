--!strict

local HttpService = game:GetService("HttpService")

local Types = require(script.Parent.Types)

local HttpTransport = {}
local missingSecretWarnings: { [string]: boolean } = {}

local function warnMissingSecret(secretName: string)
	if missingSecretWarnings[secretName] then
		return
	end

	missingSecretWarnings[secretName] = true
	warn(
		"[RaiblaxAnalytics] The Secret Store entry \""
			.. secretName
			.. "\" is unavailable. Add your Raiblax ingestion key to the experience's Secret Store."
	)
end

local function getSecret(config: Types.NormalizedConfig)
	local secretOk, secretOrError = pcall(function()
		return HttpService:GetSecret(config.secretName)
	end)

	if not secretOk or secretOrError == nil or (typeof(secretOrError) == "string" and secretOrError == "") then
		warnMissingSecret(config.secretName)
		return false, "secret_unavailable"
	end

	return true, secretOrError
end

function HttpTransport.getSecret(config: Types.NormalizedConfig): (boolean, any)
	return getSecret(config)
end

local function request(url: string, headers: { [string]: any }, body: string): (boolean, any)
	return pcall(function()
		return HttpService:RequestAsync({
			Url = url,
			Method = "POST",
			Headers = headers,
			Body = body,
		})
	end)
end

function HttpTransport.handshake(config: Types.NormalizedConfig, secret: any, jobId: string): Types.HandshakeResult
	local encoded, encodedOrError = pcall(function()
		return HttpService:JSONEncode({
			sdkVersion = config.sdkVersion,
			placeId = game.PlaceId,
			serverJobId = jobId,
			nonce = HttpService:GenerateGUID(false),
		})
	end)
	if not encoded then
		return { success = false, errorCode = "invalid_handshake_payload" }
	end

	local requestOk, responseOrError = request(config.handshakeEndpoint, {
		["Content-Type"] = "application/json",
		["x-raiblax-key"] = secret,
	}, encodedOrError)
	if not requestOk then
		return { success = false, errorCode = "handshake_request_failed" }
	end
	if not responseOrError.Success then
		return {
			success = false,
			errorCode = "handshake_rejected_status_" .. tostring(responseOrError.StatusCode),
		}
	end

	local decoded, payloadOrError = pcall(function()
		return HttpService:JSONDecode(responseOrError.Body)
	end)
	if not decoded or type(payloadOrError) ~= "table" then
		return { success = false, errorCode = "invalid_handshake_response_json" }
	end
	if type(payloadOrError.sessionToken) ~= "string" or payloadOrError.sessionToken == "" then
		return { success = false, errorCode = "invalid_handshake_response_session_token" }
	end
	if type(payloadOrError.gameId) ~= "string" and type(payloadOrError.gameId) ~= "number" then
		return { success = false, errorCode = "invalid_handshake_response_game_id" }
	end

	return {
		success = true,
		gameId = tostring(payloadOrError.gameId),
		sessionToken = payloadOrError.sessionToken,
	}
end

function HttpTransport.send(config: Types.NormalizedConfig, sessionToken: string, event: Types.AnalyticsEvent): Types.DeliveryResult
	local encodedBody: string
	local encodeOk, bodyOrError = pcall(function()
		return HttpService:JSONEncode(event)
	end)

	if not encodeOk then
		return {
			success = false,
			errorCode = "invalid_event_payload",
		}
	end
	encodedBody = bodyOrError

	local requestOk, responseOrError = request(config.endpoint, {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. sessionToken,
	}, encodedBody)

	if not requestOk then
		if config.debug then
			-- Redact the active credential; never log headers, payloads or response bodies.
			local tokenPattern = string.gsub(sessionToken, "(%W)", "%%%1")
			local detail = string.gsub(tostring(responseOrError), tokenPattern, "[REDACTED]")
			warn("[Raiblax SDK] Event RequestAsync failed: " .. detail)
		end
		return {
			success = false,
			errorCode = "request_failed",
		}
	end

	local response = responseOrError
	if config.debug then
		print("[Raiblax SDK] Event HTTP status: " .. tostring(response.StatusCode) .. "; success: " .. tostring(response.Success))
	end
	if not response.Success then
		if config.debug then
			local decoded, payload = pcall(function()
				return HttpService:JSONDecode(response.Body)
			end)
			if decoded and type(payload) == "table" and type(payload.error) == "string" then
				local tokenPattern = string.gsub(sessionToken, "(%W)", "%%%1")
				local detail = string.gsub(payload.error, tokenPattern, "[REDACTED]")
				warn("[Raiblax SDK] API rejected event: " .. detail)
			else
				warn("[Raiblax SDK] API rejected event without a JSON error message.")
			end
		end
		return {
			success = false,
			statusCode = response.StatusCode,
			errorCode = if response.StatusCode == 401 then "session_unauthorized" else "api_rejected_event",
		}
	end

	return {
		success = true,
		statusCode = response.StatusCode,
	}
end

return HttpTransport
