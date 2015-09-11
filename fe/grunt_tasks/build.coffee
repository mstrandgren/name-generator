module.exports = (grunt) ->
	grunt.config.merge

		# Paths
		paths:
			build: 'build'
			bower: 'bower_components'
			deploy: 'boilerplate'

		resource_types: ['jpg','jpeg','png','gif','svg', 'json','epub', 'mp4', 'mp3', 'webm', 'woff', 'eot', 'ttf']
		static_paths: [
			'bower_components'
			'resources'
			'res'
			'lib'
		]

		build:
			template:
				tasks: [
					'clean'
					'copy'
					'less'
					'browserify'
					# 'cacheBust'
					# 'manifest'
				]

		bower:
			template:
				cwd: '.'

		clean:
			template: ['<%= paths.build %>']

		browserify:
			app:
				files:
					'<%= paths.build %>/app.js': ['src/main.coffee']
				options:
					transform: ['coffeeify']

		less:
			all:
				options:
					paths: [
						'src'
					]
				files:
					'<%= paths.build %>/style.css': 'src/{**/,}*.less'
				expand: true

		copy:
			html:
				expand: true
				cwd: 'src'
				src: ['*.html']
				dest: '<%= paths.build %>'
			resources:
				expand: true
				cwd: 'src'
				src: ["{,**/}*.{<%= resource_types.join(',') %>}"]
				dest: '<%= paths.build %>'
			bower:
				expand: true
				cwd: 'bower_components'
				src: ['{,**/}*.{js,css}']
				dest: '<%= paths.build %>/bower_components'

		cacheBust:
			assets:
				files: [
					expand: true
					src: ['<%= paths.build %>/{,**/}*.html']
				]

		manifest:
			generate:
				options:
					basePath: "<%= paths.build %>"
					# network: ["http://*", "https://*"]
					# fallback: ["/ /offline.html"]
					# exclude: ["js/jquery.min.js"]
					preferOnline: true
					timestamp: true
				src: [
						"index.html"
						"{,**/}*.*.js"
						"{,**/}*.*.css"
				]
				dest: "<%= paths.build %>/app.appcache"

		uglify:
			options:
				mangle: true
				beautify: false

			all:
				files: [
					expand: true
					cwd: '<%= paths.build %>'
					src: '*.js'
					dest: '<%= paths.build %>'
				]

	grunt.registerMultiTask 'build', 'Build app', ->
		grunt.task.run @data.tasks

