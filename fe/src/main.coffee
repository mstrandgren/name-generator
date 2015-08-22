Ajax = require('./Ajax.coffee')
API_URL = 'http://localhost:8000'

document.addEventListener 'DOMContentLoaded', ->

	# document.getElementById('refresh').addEventListener('click', refresh)
	refresh()


refresh = ->
	Ajax.get(url: "#{API_URL}")
	.then (result) ->
		console.log result