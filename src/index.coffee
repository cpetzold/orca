
exports.Bot = require './bot'

exports.createBot = (store, opts) ->
  new exports.Bot store, opts