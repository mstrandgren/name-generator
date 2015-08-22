module.exports = (grunt) ->
	require('time-grunt')(grunt)

	grunt.initConfig({})


	require('load-grunt-tasks')(grunt)

	# Grunt config is in the respective apps
	grunt.loadNpmTasks('grunt-connect-rewrite')
	grunt.loadTasks('grunt_tasks')
	grunt.registerTask('default', ['build'])
