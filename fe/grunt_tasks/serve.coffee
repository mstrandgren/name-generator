STATIC_PATHS = [
	'bower_components'
	'resources'
	'.+\.(js|css|html|ico)'
]
STATIC_PATHS_RE = new RegExp("^\/(#{STATIC_PATHS.join('|')})")

module.exports = (grunt) ->
	grunt.config.merge

		serve:
			template:
				tasks: [
					'build:template'
					'configureRewriteRules'
					'connect:template'
					'watch'
				]

		connect:
			template:
				options:
					hostname: '*'
					port: 9001
					base: '<%= template.build %>'
					livereload: false
					open: false
					# middleware: (connect, options) ->
					# 	[
					# 		(req, res, next) ->
					# 			if not STATIC_PATHS_RE.test(req.url)
					# 				req.url = ''
					# 			next()
					# 		connect.static(require("path").resolve(options.base[0]))
					# 	]

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

