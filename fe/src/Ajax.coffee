get = (opts) ->
	opts.method = 'GET'
	request(opts)

post = (opts) ->
	opts.method = 'POST'
	request(opts)

request = ({url, method, data, headers, responseType, binary, onProgress}) ->
	method ?= 'GET'
	type = url.split('.').pop()

	return new Promise (resolve, reject) =>
		xhr = new XMLHttpRequest()

		if method == 'GET' and data?
			url += buildQueryString(data)
			data = undefined

		# xhr.withCredentials = true

		xhr.crossDomain = true

		xhr.open(method, url)

		if headers?
			xhr.setRequestHeader(key, value) for key, value of headers

		if binary
			xhr.responseType = 'arraybuffer'
			xhr.setRequestHeader('Accept', mimeType ? 'application/octet-stream')
		else
			xhr.setRequestHeader('Accept', mimeType ? 'application/json')

		xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest')

		xhr.onload = (event) =>
			try
				resolve(createSuccessResponse(xhr))
			catch e
				reject(createErrorResponse(xhr))

		xhr.onerror = (event) =>
			reject(createErrorResponse(xhr))

		xhr.onprogress = (event) ->
			progress = if event.total > 0 then event.loaded / event.total else 1
			onProgress?(progress)
			console.log("Progress #{progress}")

		xhr.send(wrapData(data))

createSuccessResponse = (xhr, opts) ->
	###
	Creates a success response for a request.
	###
	if xhr.status >= 400
		e = new Error("Error in response from server")
		e.status = xhr.status
		e.data = xhr.response
		throw e

	contentType = xhr.getResponseHeader('Content-Type')
	isJSON = contentType == 'application/json'
	isObject = (r) -> r.charAt(0) == '{'
	isArray = (r) -> r.charAt(0) == '['

	if _.isString(xhr.response) and (isJSON or isObject(xhr.response) or isArray(xhr.response))
		try
			data = JSON.parse(xhr.response)
		catch e
			throw new Error("Response is not valid JSON")
	else
		data = xhr.response

	data


createErrorResponse = (xhr) ->
	###
	Creates an error response for a request.
	###

	try
		data = JSON.parse(xhr.response)
	catch e
		data = xhr.response

	error = new Error(data?.message ? "Server error")
	error.status = xhr.status
	error.data = data
	return error

wrapData = (data) ->
	###
	If the data is a key/value dictionary and one of the values is not serializable
	(File, ArrayBuffer, etc), we need to wrap it in a FormData object.
	If it's a single value object, nothing is changed.
	If it's a key-value object but with no non-serializable values, it's cleaned
	and JSON-encoded.
	###
	if not data? or _.isString(data) # TODO or isNonSerializable(data)
		# Single value object
		return data

	if _.keys(data).length == 0
		return undefined

	values = _.values(data)
	numValues = values.length
	hasNonSerializableValue = values.map(isNonSerializable).reduce((a,b) -> a or b)

	if numValues > 0
		# Key value object
		formData = new FormData()
		for key, value of data
			# Satisfying Firefox's sick desires with this if clause
			# formData.append(key, value, value.name) should be enough, but Firefox will scream bloody murder
			if value?.name?
				formData.append(key, value, value.name)
			else if isNonSerializable(value) or not _.isObject(value)
				formData.append(key, value)
			else
				formData.append(key, JSON.stringify(value))

		return formData

	if _.isObject(data)
		cleanBundle = {}
		for id, object of data
			if _.isObject(object) and not _.isArray(object)
				cleaned = cleanObject(object)
			else
				cleaned = object
			cleanBundle[id] = cleaned
		return JSON.stringify(cleanBundle)
	else
		throw new Error("Illegal request data type: #{data}")

buildQueryString = (data) ->
	###
	Takes a javascript object and turns it to a query string usable with
	GET request. The first level of keys will be the query string keys,
	lower level objects will be converted to JSON strings.
	###
	if not data? or _.isEmpty(data) then return ""
	tokens = []
	for key, value of data
		if _.isObject(value)
			value = JSON.stringify(value)
		if value != undefined
			tokens.push "#{key}=#{encodeURIComponent(value)}"

	return '?' + tokens.join('&')

isNonSerializable = (object) ->
	return (
		object instanceof File or
		object instanceof Blob or
		object instanceof Document or
		object instanceof ArrayBuffer or
		object instanceof FormData)

cleanObject = (object) ->
	cleaned = {}
	for key, val of object
		if key.indexOf('$$') == 0 or key.indexOf('_') == 0
			continue
		else if val instanceof Array
			cleaned[key] = val
		else if val instanceof Object
			cleaned[key] = cleanObject(val)
		else
			cleaned[key] = val
	return cleaned


module.exports = {
	get
	post
}
