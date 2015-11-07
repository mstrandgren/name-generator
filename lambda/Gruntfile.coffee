module.exports = (grunt) ->
	grunt.initConfig
		functionName: 'NameGeneratorAPI'

	require('load-grunt-tasks')(grunt)

	grunt.config.merge

		build:
			all:
				tasks: [
					'clean'
					'coffee'
					'copy'
				]

		clean:
			all: ['build']

		coffee:
			all:
				expand: true
				flatten: true
				cwd: 'src'
				src: ['*.coffee']
				dest: 'build'
				ext: '.js'

		copy:
			package:
				expand: true
				cwd: '.'
				src: [
					'package.json'
				]
				dest: 'build'

		deploy:
			all:
				tasks: [
					'build'
					'lambda_package'
					'lambda_deploy'
				]

		lambda_package:
			default:
				options:
					package_folder: ['build']

		lambda_deploy:
			default:
				options:
					region: 'eu-west-1'

				arn: 'arn:aws:lambda:eu-west-1:066341227319:function:<%= functionName %>'

	grunt.registerMultiTask 'deploy', 'Deploy to aws', ->
		grunt.task.run @data.tasks

	grunt.registerMultiTask 'build', 'Build js bundle', ->
		grunt.task.run @data.tasks

	grunt.registerTask('default', ['build'])
