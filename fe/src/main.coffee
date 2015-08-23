Ajax = require('./Ajax.coffee')
API_URL = 'http://localhost:9000'

document.addEventListener 'DOMContentLoaded', ->

	document.getElementById('refresh').addEventListener('click', refresh)
	refresh()

$ = (sel) ->
	document.querySelector(sel)

_el = (id) ->
	document.getElementById(id)

refresh = ->
	_el('ui').classList.add('loading')
	generateName()
	.then (name) ->
		_el('ui').classList.remove('loading')
		_el('generated-name').innerHTML = name
		_el('get-domain').value = "Register #{name} on Gandi.net"


generateName = ->
	# Ajax.get(url: "#{API_URL}")

	names = ['machinedot.com', 'mostformal.com', 'gladplant.com']

	Promise.resolve(_.sample(names))