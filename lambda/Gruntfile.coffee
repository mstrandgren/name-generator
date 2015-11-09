module.exports = (grunt) ->
	grunt.initConfig
		mf:
			region: 'eu-west-1'
			account: '066341227319'
			lambdaFunctionName: 'NameGeneratorAPI'

	require('load-grunt-tasks')(grunt)
	require('mflib/grunt/lambda')(grunt)

	grunt.registerTask('default', ['build'])
