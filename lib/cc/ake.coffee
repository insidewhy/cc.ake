{exec}   = require 'child_process'
console  = require 'console'
path     = require 'path'

assertCmds = []

# add node_modules binaries to head of path
exports.nodeModulePath = ->
    process.env.PATH = "#{path.join process.cwd(), 'node_modules', '.bin'}:" + process.env.PATH

exports.invoke = (cmds...) ->
  return -> invoke cmd for cmd in cmds

exports.assert = (cmd...) ->
  if assertCmds.length
    assertCmds = assertCmds.concat cmd
    return
  else
    assertCmds = cmd

  do helper = ->
    return unless assertCmds.length
    first = assertCmds[0]
    if typeof first == 'string'
      exec first, (err, stdout, stderr) ->
        if err
          console.warn "error: #{stderr.trim()}"
          process.exit 1
        else
          do assertCmds.shift
          do helper
    else
      try
        do first
        do assertCmds.shift
        do helper
      catch e
        console.warn "error: #{e}"
        process.exit 1
  return
# vim:ts=2 sw=2
