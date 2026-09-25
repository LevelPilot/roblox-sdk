--!strict

export type Properties = { [string]: unknown }

export type InitOptions = {
	endpoint: string?,
	handshakeEndpoint: string?,
	allowInsecureHttp: boolean?,
	secretName: string?,
	debug: boolean?,
	autoFlush: boolean?,
}

export type NormalizedConfig = {
	endpoint: string,
	handshakeEndpoint: string,
	allowInsecureHttp: boolean,
	secretName: string,
	sdkVersion: string,
	sessionRefreshSeconds: number,
	debug: boolean,
	autoFlush: boolean,
}

export type AnalyticsEvent = {
	eventName: string,
	occurredAt: string,
	properties: Properties,
	context: {
		gameId: number,
		placeId: number,
		jobId: string,
	},
}

export type DeliveryResult = {
	success: boolean,
	statusCode: number?,
	errorCode: string?,
}

export type HandshakeResult = {
	success: boolean,
	gameId: string?,
	sessionToken: string?,
	errorCode: string?,
}

return {}
