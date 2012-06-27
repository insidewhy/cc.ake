# cc.ake

## Installation
```
npm install -g cc.ake
```

## Usage

```coffeescript
ake    = require 'cc.ake'

# add node_modules binaries to head of path
do ake.nodeModulePath

# ensure every argument passes. strings are treated as unix commands and
# functions are run normally. Either a bad shell exit status or an exception
# thrown from a function will cause the process to exit.
ake.assert 'rm -f bad',
  ake.invoke 'othertask' # invoke another task
  'cp -n something somewhere' # if exit status is bad, terminate process
  'echo yo'
  ->
    do stuff
  ->
    # this will terminate the coffeescript process
    throw "an error"

ake.watch 'testdir',
  /.coffee$/, (fname) ->
    console.log 'changed', fname
    exec 'coffee -c testdir'
  /.js$/, (fname) ->
    console.log 'js updated', fname
```
