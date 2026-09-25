--!strict

local Types = require(script.Parent.Types)

local EventFactory = {}

local MAX_EVENT_NAME_LENGTH = 128

function EventFactory.create(eventName: string, properties: Types.Properties?): Types.AnalyticsEvent
	assert(type(eventName) == "string" and #eventName > 0, "eventName must be a non-empty string")
	assert(#eventName <= MAX_EVENT_NAME_LENGTH, "eventName is too long")
	assert(eventName:match("^[%a_][%w_%.%-]*$") ~= nil, "eventName contains unsupported characters")
	assert(properties == nil or type(properties) == "table", "properties must be a table")

	return {
		eventName = eventName,
		occurredAt = os.date("!%Y-%m-%dT%H:%M:%SZ"),
		properties = properties or {},
		context = {
			gameId = game.GameId,
			placeId = game.PlaceId,
			jobId = game.JobId,
		},
	}
end

return EventFactory
