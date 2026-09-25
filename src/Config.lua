--!strict

local Types = require(script.Parent.Types)

local DEFAULT_ENDPOINT = "https://api.raiblax.com/v1/events"
local DEFAULT_HANDSHAKE_ENDPOINT = "https://api.raiblax.com/api/v1/sdk/handshake"
local DEFAULT_SECRET_NAME = "RAIBLAX_API_KEY"
local SDK_VERSION = "1.0.0"
local SESSION_REFRESH_SECONDS = 14 * 60

local Config = {}

local function isPermittedEndpoint(endpoint: string, allowInsecureHttp: boolean): boolean
	if endpoint:match("^https://") then
		return true
	end
	return allowInsecureHttp and endpoint:match("^http://localhost:%d+/") ~= nil
end

function Config.normalize(options: Types.InitOptions?): Types.NormalizedConfig
	options = options or {}

	local allowInsecureHttp = options.allowInsecureHttp == true
	local endpoint = options.endpoint or DEFAULT_ENDPOINT
	assert(type(endpoint) == "string" and isPermittedEndpoint(endpoint, allowInsecureHttp), "endpoint must be HTTPS, except localhost HTTP for local testing")

	local secretName = options.secretName or DEFAULT_SECRET_NAME
	assert(type(secretName) == "string" and #secretName > 0, "secretName must be a non-empty string")

	local handshakeEndpoint = options.handshakeEndpoint or DEFAULT_HANDSHAKE_ENDPOINT
	assert(type(handshakeEndpoint) == "string" and isPermittedEndpoint(handshakeEndpoint, allowInsecureHttp), "handshakeEndpoint must be HTTPS, except localhost HTTP for local testing")

	return {
		endpoint = endpoint,
		handshakeEndpoint = handshakeEndpoint,
		allowInsecureHttp = allowInsecureHttp,
		secretName = secretName,
		sdkVersion = SDK_VERSION,
		sessionRefreshSeconds = SESSION_REFRESH_SECONDS,
		debug = options.debug == true,
		autoFlush = options.autoFlush ~= false,
	}
end

return Config
