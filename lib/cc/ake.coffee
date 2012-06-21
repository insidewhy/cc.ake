{exec}   = require 'child_process'
console  = require 'console'
path     = require 'path'

# add node_modules binaries to head of path
exports.nodeModulePath = ->
    process.env.PATH = "#{path.join process.cwd(), 'node_modules', '.bin'}:" + process.env.PATH

exports.invoke = (cmds...) ->
  return -> invoke cmd for cmd in cmds

exports.assert = (cmd...) ->
  do helper = ->
    return unless cmd.length
    first = cmd[0]
    if typeof first == 'string'
      exec first, (err, stdout, stderr) ->
        if err
          console.warn "error: #{stderr.trim()}"
          process.exit 1
        else
          do cmd.shift
          do helper
    else
      try
        do first
        do cmd.shift
        do helper
      catch e
        console.warn "error: #{err}"
        process.exit 1
# vim:ts=2 sw=2
