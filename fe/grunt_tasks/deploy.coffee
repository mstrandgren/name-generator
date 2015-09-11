module.exports = (grunt) ->

	grunt.config.merge
		deploy:
			app:
				tasks: [
					'aws_s3:app'
				]

		clean_remote:
			app:
				tasks: [
					'aws_s3:clean'
				]

		aws: grunt.file.readJSON('grunt-aws.json')

		aws_s3:
			options:
				accessKeyId: '<%= aws.key %>'
				secretAccessKey: '<%= aws.secret %>'
				bucket: '<%= aws.bucket %>'
				region: '<%= aws.region %>'
				access: 'public-read'
				params:
					CacheControl: "max-age=#{1000*60}, public",
					Expires: new Date(Date.now() + 1000*60)
					# ContentEncoding: 'gzip'
				# gzip: true
				# gzipExclude: ['.mp4', '.ogg', '.ogv', '.jpg', '.png']
				# debug: true
				differential: true

			app:
				files: [
					expand: true
					cwd: '<%= paths.build %>'
					dest: '<%= paths.deploy %>'
					src: ['**']
				]

			clean:
				files: [
					cwd: '<%= paths.build %>'
					dest: '<%= paths.deploy %>'
					action: 'delete'
					differential: true
				]

	grunt.registerMultiTask 'deploy', 'Push to s3', ->
		grunt.task.run @data.tasks

	grunt.registerMultiTask 'clean_remote', 'Delete from s3', ->
		grunt.task.run @data.tasks