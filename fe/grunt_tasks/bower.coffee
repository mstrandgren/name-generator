module.exports = (grunt) ->
	grunt.registerMultiTask 'bower', 'install bower dependencies', ->
		path = require('path')
		bower = require('bower')
		done = @async()

		if @data.cwd
			cwd = path.resolve(@data.cwd)

		bower.commands.install(null, null, cwd: cwd)
		.on 'log', (result) ->
			grunt.log.writeln(['bower', result.id.cyan, result.message].join(' '))
		.on 'error', (code) ->
			grunt.fatal(code)
		.on 'end', ->
			# Make sure we update all the dependencies.
			bower.commands.update(null, null, cwd: cwd)
			.on 'log', (result) ->
				grunt.log.writeln(['bower', result.id.cyan, result.message].join(' '))
			.on 'error', (code) ->
				grunt.fatal(code)
			.on('end', done)