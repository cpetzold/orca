{ Client } = require('irc');

module.exports = class Bot
  constructor: (opts = {}) ->
    store = opts.store

    if !store
      throw new Error 'Must pass in a store'

    opts.network ?= 'the0th'
    opts.server ?= 'irc.the0th.com';
    opts.channels ?= [ '#derbyjs', '#pwn' ]
    opts.port ?= 6667
    opts.nick ?= 'derbybot'

    refPath = opts.refPath ? '_messages'
    toPath = opts.toPath ? 'messages'
    keyPath = opts.keyPath ? '_messageIds'

    model = store.createModel()
    model.refList refPath, toPath, keyPath
    @messages = model.at refPath

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
    message.channel = to.replace '#', ''
    message.timestamp = Date.now()
    console.log message
    @messages.push message