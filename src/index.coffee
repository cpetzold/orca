path = require 'path'

orca = module.exports = require './app'

orca.root = path.dirname __dirname
orca.assets = path.join orca.root, 'public'

orca.Bot = require './bot'
orca.createBot = (opts) ->
  new orca.Bot opts