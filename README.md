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
# functions are run normally. Each type signals an error differently
# and any error causes the coffeescript process to exit.
ake.assertAll 'rm -f bad',
  'cp -n something somewhere' # if exit status is bad, terminate process
  'echo yo'
  ->
    do stuff
    return true # return anything other than string to signal success
  ->
    # this will terminate the coffeescript process
    return "an error string"
```
