module.exports = (grunt) ->
	grunt.config.merge
		aws: grunt.file.readJSON('aws.json')

		deploy:
			production:
				tasks: [
					'build'
					's3'
				]


		s3:
			options:
				key: '<%= aws.key %>'
				secret: '<%= aws.secret %>'
				bucket: '<%= aws.bucket %>'
				region: '<%= aws.region %>'
				access: 'public-read'
				headers:
					"Cache-Control": "max-age=#{1000*60}, public",
					"Expires": new Date(Date.now() + 1000*60).toUTCString()

			all:
				upload: [
					expand: true
					src: '<%= template.build %>/*'
					dest: '/'
					rel: '<%= template.build %>'
				]

	grunt.registerMultiTask 'deploy', 'Push app to s3', ->
		grunt.task.run @data.tasks
