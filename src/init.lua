--!strict

local HttpService = game:GetService("HttpService")

local Config = require(script.Config)
local EventFactory = require(script.EventFactory)
local HttpTransport = require(script.HttpTransport)
local Types = require(script.Types)

local Analytics = {}

local config: Types.NormalizedConfig? = nil
local pendingEvents: { Types.AnalyticsEvent } = {}
local sessionToken: string? = nil
local sessionRefreshAt = 0
local apiKey: any = nil
local lastInitializationError: string? = nil
local studioJobId = "studio-" .. HttpService:GenerateGUID(false)

local function requireConfig(): Types.NormalizedConfig
	assert(config ~= nil, "Analytics.init() must be called before tracking events")
	return config
end

local function currentJobId(): string
	if game.JobId ~= "" then
		return game.JobId
	end
	return studioJobId
end

local function handshakeFailureMessage(errorCode: string): string
	local messages = {
		handshake_request_failed = "request could not reach the endpoint; verify that HTTP requests are enabled and the endpoint is reachable.",
		handshake_rejected_status_400 = "server rejected the request payload; verify the SDK and handshake contract.",
		handshake_rejected_status_401 = "SDK key was rejected; create an active ingestion key and update RAIBLAX_API_KEY in Local Secrets.",
		handshake_rejected_status_403 = "SDK key is not authorized for this game.",
		handshake_rejected_status_404 = "handshake endpoint was not found; verify HandshakeEndpoint.",
		handshake_rejected_status_429 = "server rate-limited the handshake; retry after a short delay.",
		handshake_rejected_status_500 = "server encountered an internal error.",
		handshake_rejected_status_503 = "server handshake service is unavailable.",
		invalid_handshake_payload = "SDK could not encode the handshake payload.",
		invalid_handshake_response_json = "server returned a response that is not valid JSON.",
		invalid_handshake_response_session_token = "server response did not include a valid session token.",
		invalid_handshake_response_game_id = "server response did not include a valid game ID.",
	}
	return messages[errorCode] or "handshake failed (" .. errorCode .. ")."
end

local function establishSession(): boolean
	local currentConfig = requireConfig()
	if apiKey == nil then
		lastInitializationError = "secret_unavailable"
		return false
	end

	local result = HttpTransport.handshake(currentConfig, apiKey, currentJobId())
	if not result.success or result.sessionToken == nil or result.gameId == nil then
		lastInitializationError = result.errorCode or "handshake_failed"
		warn("[Raiblax SDK] Handshake failed: " .. handshakeFailureMessage(lastInitializationError))
		return false
	end

	sessionToken = result.sessionToken
	sessionRefreshAt = time() + currentConfig.sessionRefreshSeconds
	lastInitializationError = nil
	print("[Raiblax SDK] Handshake succeeded for game " .. result.gameId .. ".")
	return true
end

local function ensureSession(): boolean
	if sessionToken ~= nil and time() < sessionRefreshAt then
		return true
	end
	return establishSession()
end

function Analytics.init(options: Types.InitOptions?): boolean
	assert(config == nil, "Analytics.init() can only be called once")
	local normalizedConfig = Config.normalize(options)
	config = normalizedConfig
	local secretOk, secretOrError = HttpTransport.getSecret(normalizedConfig)
	if not secretOk then
		lastInitializationError = "secret_unavailable"
		config = nil
		return false
	end
	apiKey = secretOrError
	if not establishSession() then
		config = nil
		apiKey = nil
		return false
	end

	return true
end

function Analytics.getLastInitializationError(): string?
	return lastInitializationError
end

function Analytics.track(eventName: string, properties: Types.Properties?): (boolean, string?)
	local currentConfig = requireConfig()
	local event = EventFactory.create(eventName, properties)
	table.insert(pendingEvents, event)

	if not currentConfig.autoFlush then
		return true
	end

	return Analytics.flush()
end

function Analytics.flush(): (boolean, string?)
	local currentConfig = requireConfig()
	local delivered = 0

	while #pendingEvents > 0 do
		local event = pendingEvents[1]
		if not ensureSession() then
			return false, "session_unavailable"
		end

		local result = HttpTransport.send(currentConfig, sessionToken :: string, event)
		if result.statusCode == 401 then
			sessionToken = nil
			if ensureSession() then
				result = HttpTransport.send(currentConfig, sessionToken :: string, event)
			end
		end

		if not result.success then
			return false, result.errorCode
		end

		table.remove(pendingEvents, 1)
		delivered += 1
	end

	return true
end

function Analytics.getPendingEventCount(): number
	return #pendingEvents
end

return Analytics
