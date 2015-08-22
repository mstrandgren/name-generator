module.exports = (grunt) ->
	grunt.config.merge

		# Paths
		template:
			build: 'build'
			bower: 'bower_components'

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
			template: ['<%= template.build %>']

		browserify:
			template:
				files:
					'<%= template.build %>/main.js': ['src/main.coffee']
				options:
					transform: ['coffeeify']

		less:
			template:
				options:
					paths: [
						'src'
					]
				files:
					'build/style.css': 'src/{**/,}*.less'
				expand: true

		copy:
			html:
				expand: true
				cwd: 'src'
				src: ['*.html']
				dest: '<%= template.build %>'
			resources:
				expand: true
				cwd: 'src'
				src: ['{,**/}*.{jpg,png,gif,json,epub}']
				dest: '<%= template.build %>'
			bower:
				expand: true
				cwd: 'bower_components'
				src: ['{,**/}*.{js,css}']
				dest: '<%= template.build %>/bower_components'

		cacheBust:
			assets:
				files: [
					expand: true
					src: ['<%= template.build %>/{,**/}*.html']
				]

		manifest:
			generate:
				options:
					basePath: "<%= template.build %>"
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
				dest: "<%= template.build %>/voc.appcache"

		uglify:
			options:
				mangle: true
				beautify: false

			template:
				files: [
					expand: true
					cwd: '<%= template.build %>'
					src: '*.js'
					dest: '<%= template.build %>'
				]

	grunt.registerMultiTask 'build', 'Build app', ->
		grunt.task.run @data.tasks

