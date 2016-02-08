gulp = require 'gulp'

browserify = require 'browserify'
watchify = require 'watchify'

# rename = require 'gulp-rename'
imagemin = require 'gulp-imagemin'
watch = require 'gulp-watch'
sass = require 'gulp-sass'
changed = require 'gulp-changed'

del = require 'del'
colors = require 'colors'
assign = require 'lodash.assign'
source = require 'vinyl-source-stream'

# TODO: remove redundant pkgs.

files = [
  {
    input : ['./source/javascripts/content.coffee']
    output : 'content.js'
    extensions : ['.coffee']
    destination: './build/javascripts'
  }
  {
    input : ['./source/javascripts/background.coffee']
    output : 'background.js'
    extensions : ['.coffee']
    destination: './build/javascripts'
  }
  {
    input : ['./source/javascripts/main.coffee']
    output : 'main.js'
    extensions : ['.coffee']
    destination: './build/javascripts'
  }
]

paths =
  js:
    source: './source/javascripts/**/*'
    build: './build/javascripts'
  images:
    source: './source/images/**/*'
    build: './build/images'
  views:
    source: './source/views/**/*'
    build: './build/views'
  styles:
    source: './source/stylesheets/**/*' # TODO: .scss, .sass, .css
    build: './build/stylesheets'

# TODO: export minified always with uglifyify transform
# ...and also uglify at the same time?
createBundle = (opts) ->
  customOpts =
    debug: true
    entries: opts.input
    extensions: opts.extensions

  mergedOpts = assign { }, watchify.args, customOpts

  bfy = watchify browserify(mergedOpts)

  bundle = (ids) ->
    bfy.bundle()
      .on 'error', console.log
      .pipe source(opts.output)
      # Add transformations here or in package.json
      .pipe gulp.dest(opts.destination)
      .on 'end', ->
        console.log "'#{opts.output.cyan}' was browserified"

  bfy.on 'update', bundle
  bfy.on 'log', console.log

  bundle()

createBundles = (files) ->
  files.forEach (file) ->
    createBundle
      input: file.input
      output: file.output
      extensions: file.extensions
      destination: file.destination

gulp.task 'js', ['clean-js'], ->
  # TODO: Rename to include the word watch?
  createBundles files

gulp.task 'images', ['clean-images'], ->
  gulp.src(paths.images.source) # TODO: read: false? -- prob. not
    .pipe changed(paths.images.build)
    .pipe imagemin(optimizationLevel: 5) # TODO: Tweak optimization level & opts
    .pipe gulp.dest(paths.images.build)

gulp.task 'views', ['clean-views'], ->
  gulp.src(paths.views.source)
    .pipe changed(paths.views.build)
    # minify-html
    .pipe gulp.dest(paths.views.build)

gulp.task 'styles', ['clean-styles'], ->
  gulp.src(paths.styles.source) # TODO: read: false? -- prob. not
    .pipe changed(paths.styles.build, extension: '.css')
    .pipe sass()
    # minification, compression plugin or settings for sass?
    .pipe gulp.dest(paths.styles.build)

gulp.task 'vendor', ['clean-vendor'], ->
  gulp.src('./vendor/**/*', cwd: './')
    .pipe changed('./vendor', cwd: './build')
    .pipe gulp.dest('./vendor', cwd: './build')

gulp.task 'manifest', ->
  gulp.src('manifest.json', cwd: './source') # TODO
    .pipe changed('.', cwd: './build') # TODO
    .pipe gulp.dest('.', cwd: './build') # TODO

gulp.task 'credentials', ->
  gulp.src('client_id.json', cwd: '.')
    .pipe changed('.', cwd: './build')
    .pipe gulp.dest('.', cwd: './build')

# gulp.task 'watch', ->
  # TODO: Do we need to clean on each watch? If we do, leave
  # like this, but if we don't, move watching inside of each task

  # watch [paths.images.source, '!**/*.tmp' ], { read: false }, (file) ->
  #   console.log("'#{file.path.cyan}' -> #{file.event.magenta}")

  # watch paths.views.source, { read: false }, (file) ->
  #   console.log('views')
  #
  # watch paths.styles.source, { read: false }, (file) ->
  #   console.log('styles')

# TODO: styles

gulp.task 'default', [
  'js',
  'images',
  'views',
  'styles',
  'vendor',
  'manifest', 'credentials'
], ->

gulp.task 'clean-js', (cb) ->
  # TODO: also can return stream
  del ['./build/javascripts'], cb

gulp.task 'clean-images', (cb) ->
  # TODO: also can return stream
  del ['./build/images'], cb

gulp.task 'clean-views', (cb) ->
  # TODO: also can return stream
  del ['./build/views'], cb

gulp.task 'clean-styles', (cb) ->
  # TODO: also can return stream
  del ['./build/stylesheets'], cb

gulp.task 'clean-vendor', (cb) ->
  # TODO: also can return stream
  del ['./build/vendor'], cb

# TODO:
  # * uglify (add options -cm, does this keep source maps intact?)
  # * uglifyify (add options -cm, should keep maps intact...)
  # * coffee-lint
  # * jshint/lint
  # * minify-html
  # * strip debug
  # * mocha
  # * vinyl-paths if want to easily get files from paths when using pipe
  # * https://www.npmjs.com/package/errorify
  # * gulp-cached
