{exec}   = require 'child_process'
console  = require 'console'
path     = require 'path'

# add node_modules binaries to head of path
exports.nodeModulePath = ->
    process.env.PATH = "#{path.join process.cwd(), 'node_modules', '.bin'}:" + process.env.PATH

exports.assertAll = (cmd...) ->
  do assertHelper = ->
    return unless cmd.length
    first = cmd[0]
    if typeof first == 'string'
      exec first, (err, stdout, stderr) ->
        if err
          console.warn "error: #{stderr.trim()}"
          process.exit 1
        else
          do cmd.shift
          do assertHelper
    else
      err = do first
      if typeof err is 'string'
        console.warn "error: #{err}"
        process.exit 1
      do cmd.shift
      do assertHelper

