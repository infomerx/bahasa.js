{exec} = require 'child_process'

task 'build', 'Build bahasa.js from source', -> compile()

compile = (callback) ->
  exec 'coffee -o lib/ -c src/', (err, stdout, stderr) ->
    throw err if err
    console.log "Compiled coffee files"
    callback?()