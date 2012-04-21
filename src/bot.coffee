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

    @path = opts.path ? 'channels.'
    @path += '.' if not @path.match '.'

    @client = new Client opts.server, opts.nick, opts
    @client.on 'message', @onMessage
    @client.on 'join', @onJoin
    @client.on 'part', @onPart

  onMessage: (from, to, message) =>
    @push to,
      type: 'message'
      from: from
      message: message

  onJoin: (to, from) =>
    @push to,
      type: 'join'
      from: from

  onPart: (to, from) =>
    @push to,
      type: 'part'
      from: from

  push: (to, message) ->
    path = @path + to.replace '#', ''
    message.timestamp = Date.now()
    @store.push path + '.messages', message, null