{exec}   = require 'child_process'
console  = require 'console'
path     = require 'path'
fs       = require 'fs'

assertCmds = []

# add node_modules binaries to head of path
exports.nodeModulePath = ->
    process.env.PATH = "#{path.join process.cwd(), 'node_modules', '.bin'}:" + process.env.PATH

exports.invoke = (cmds...) ->
  return -> invoke cmd for cmd in cmds

# watch files for changes, returning true unless the system does not support
# file watches
exports.watch = (dir, args...) ->
  return false unless fs.watch

  regexps = []
  while args.length
    regexps.push [ args.shift(), args.shift() ]

  ignoreUntil = {} # ignore fast changes
  fs.watch dir, (event, fname) ->
    return unless event is 'change'
    for regexp in regexps
      if regexp[0].test fname
        now = new Date().getTime()
        return if ignoreUntil[fname] and now < ignoreUntil[fname]
        regexp[1](fname)
        ignoreUntil[fname] = now + 100
        return
    return
  true

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

exports.cp = (src, dest) ->
  fs.createReadStream(src).pipe(fs.createWriteStream(dest))

exports.lnsf = (src, dest) ->
  fs.symlinkSync src, dest unless fs.existsSync dest

# vim:ts=2 sw=2
