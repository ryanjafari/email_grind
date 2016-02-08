# TODO: use gulp w/ coffee?
# http://frontendbabel.info/articles/developing-cross-browser-extensions/
# https://github.com/salsita/chrome-extension-skeleton

# fs = require('fs')
# path = require('path')
# exec = require('child_process').exec
# spawn = require('child_process').spawn
#
# ROOT_PATH = __dirname
# SOURCE_PATH = path.join(ROOT_PATH, '/app/src')
# BUILD_PATH = path.join(ROOT_PATH, '/app/build')
# ENTRY_POINT = 'content.coffee'
# BUNDLE_FILE = 'bundle.js'
# BUNDLE_FILE_MIN = 'bundle.min.js'
# BUNDLE_SOURCE_MAP = 'bundle.map.json'

# task 'test', 'Runs all Jasmine specs in spec/ folder', ->
#   test()

# task 'compile', 'Compiles coffee in src/ to js in bin/', ->
#   compile()

# task 'watch', '', ->
#   watchify()

# task 'build', 'Creates a single bundled javascript file from sources', ->
#   # TODO: test first
#   browserify()
#
# task 'build_and_compress', 'Build and compress bundled file', ->
#   # TODO: test first
#   browserify_and_uglifyify -> compress()

# bin_available = (bin) ->
#   present = false
#   process.env.PATH.split(':').forEach (value, index, array) ->
#     present || = fs.existsSync("#{value}/#{bin}")
#   present
#
# if_available = (bin, callback) ->
#   if bin_available(bin)
#     callback()
#   else
#     console.log("#{bin} can\'t be found in your $PATH.")
#     process.exit(-1)
#
# log = (data) ->
#   console.log data.toString().replace('\n', '')

# TODO: export minified always with uglifyify transform
# watchify = (callback) ->
#   if_available 'watchify', ->
#     opts = [
#       '--extension', '.coffee',
#       '-e', "#{SOURCE_PATH}/#{ENTRY_POINT}",
#       '-o', "#{BUILD_PATH}/#{BUNDLE_FILE}",
#       '-d'
#     ]
#
#     ps = spawn('watchify', opts)
#     ps.stdout.on('data', log)
#     ps.stderr.on('data', log)
#     ps.on 'exit', (code) ->
#       if code != 0
#         console.log 'Watchify failed'

# Browserify with the source maps intact
# browserify = (callback) ->
#   if_available 'browserify', ->
#     source = "#{SOURCE_PATH}/#{ENTRY_POINT}"
#     build = "#{BUILD_PATH}/#{BUNDLE_FILE}"
#
#     exec "browserify
#       -t [coffeeify --sourceMap true]
#       --extension='.coffee'
#       -e #{source} -o #{build} -d", (err, stdout, stderr) ->
#       throw err if err
#       console.log('Browserified javascript file')
#       callback?()

# Keep source maps intact when uglifying, good for debugging in production
# browserify_and_uglifyify = (callback) ->
#   if_available 'browserify', ->
#     source = "#{SOURCE_PATH}/#{ENTRY_POINT}"
#     build = "#{BUILD_PATH}/#{BUNDLE_FILE}"
#
#     # TODO: add uglify options here -cm
#     exec "browserify
#       -t [coffeeify --sourceMap true]
#       -t uglifyify
#       --extension='.coffee'
#       -e #{source} -o #{build} -d", (err, stdout, stderr) ->
#       throw err if err
#       console.log('Browserified and uglifyified javascript file')
#       callback?()

# Compress and not care about the source map
# TODO: does this keep source maps intact or what?
# compress = (callback) ->
#   if_available 'uglifyjs', ->
#     input = "#{BUILD_PATH}/#{BUNDLE_FILE}"
#     output = "#{BUILD_PATH}/#{BUNDLE_FILE_MIN}"
#
#     exec "uglifyjs #{input} -o #{output} -cm", (err, stdout, stderr) ->
#       throw err if err
#       console.log('Compressed bundled file')
#       callback?()

# TODO: use spawn here?
# TODO: use mocha here
# test = (callback) ->
#   console.log "Running Jasmine specs"
#   exec 'jasmine-node --coffee spec/', (err, stdout, stderr) =>
#     console.log stdout + stderr
#
#     # hack to work around jasmine-node's bad return vals:
#     throw "Tests fail. Build fails. You fail." if ~stdout.indexOf "Expected"
#
#     callback?()

# compile = (callback) ->
#   if_available 'coffee', ->
#     exec "coffee -c #{SOURCE_PATH} -o #{BUILD_PATH}", (err, stdout, stderr) ->
#       throw err if err
#       console.log('Compiled coffee files')
#       callback?()

# NOTE: this also uses uglify, but support for Browserify above 11 dropped?
# Keep source maps intact when minifying, good for debugging in production
# browserify_and_minifyify = (callback) ->
#   if_available 'browserify', ->
#     source = "#{SOURCE_PATH}/#{ENTRY_POINT}"
#     build = "#{BUILD_PATH}/#{BUNDLE_FILE}"
#     minifyify = "[minifyify
#       --map #{BUILD_PATH}/#{BUNDLE_SOURCE_MAP}
#       --output #{BUILD_PATH}/#{BUNDLE_SOURCE_MAP}]"
#
#     exec "browserify
#       -t [coffeeify --sourceMap true]
#       --extension='.coffee'
#       -e #{source} -o #{build} -d -p #{minifyify}", (err, stdout, stderr) ->
#       throw err if err
#       console.log('Browserified and minifyified javascript file')
#       callback?()
