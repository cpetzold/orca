{ Client } = require('irc');

module.exports = class Bot
  constructor: (opts = {}) ->
    @store = opts.store

    if !@store
      throw new Error 'Must pass in a store'

    opts.server ?= 'irc.the0th.com';
    opts.channels ?= [ '#derbyjs' ]
    opts.port ?= 6667
    opts.nick ?= 'derbybot'

    @path = opts.path ? 'messages'
    @client = new Client opts.server, opts.nick, opts

    @client.addListener 'message', @onMessage

  onMessage: (from, to, message) =>
    console.log from, to, message
    @store.push @path, { from, message }, null