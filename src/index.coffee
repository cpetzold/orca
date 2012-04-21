{ Client } = require('irc');

module.exports = (store, options) ->
  console.log store.constructor.name

  return

  # if not store or 
  #   throw new Error 'Must pass in a store'

  # options ?= {}
  # options.server = options.server || 'irc.freenode.net';
  # options.nick = 'derbybot';
  # options.channels = ['#derby'];

  # client = new Client options.server