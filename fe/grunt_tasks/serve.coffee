
module.exports = (grunt) ->
	grunt.config.merge

		serve:
			http:
				tasks: [
					'connect:http'
					'watch'
				]
			https:
				tasks: [
					'connect:https'
					'watch'
				]

		connect:
			http:
				options:
					protocol: 'http'
			https:
				options:
					protocol: 'https'
			options:
				hostname: '*'
				port: 9001
				base: '<%= paths.build %>'
				static_paths_re: "^\/(<%= static_paths.join('|') %>)"
				static_types_re: "\.(html|css|js|ico|<%= resource_types.join('|') %>)$"
				livereload: false
				open: false
				middleware: (connect, options, middlewares) ->
					pathRe = new RegExp(options.static_paths_re)
					typeRe = new RegExp(options.static_types_re)
					middlewares.unshift (req, res, next) ->
						if not pathRe.test(req.url) and not typeRe.test(req.url)
							req.url = '/'
						next()
					return middlewares

		watch:
			coffee:
				options:
					livereload: false
				files: [
					'src/{,**/}*.coffee'
					'src/{,**/}*.cjsx'
				]
				tasks: [
					'browserify'
					# 'cacheBust'
					# 'manifest'
				]
			html:
				options:
					livereload: false
				files: [
					'src/{,**/}*.html'
				]
				tasks: [
					'copy:html'
					# 'cacheBust'
					# 'manifest'
				]
			less:
				options:
					livereload: false
				files: [
					'src/{,**/}*.less'
				]
				tasks: [
					'less'
					# 'cacheBust'
					# 'manifest'
				]

	grunt.registerMultiTask 'serve', 'Serve serve script locally', ->
		grunt.task.run @data.tasks

