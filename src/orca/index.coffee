derby = require 'derby'
moment = require 'moment'

orca = derby.createApp module

orca.view.fn 'prettyDate', (d) ->
  moment(d).format 'hh:mm:ss a'

orca.get '/', (page) ->
  page.redirect '/derbyjs'

orca.get '/:channel', (page, model, params) ->
  messageQuery = model.query 'messages',
    where:
      channel: params.channel
  messageQuery.sort 'timestamp', 'desc'

  model.subscribe "channels.#{params.channel}", messageQuery, (e, channel, messages) ->
    list = []
    for id, message of messages.get()
      list.push message

    list.sort (a, b) -> a.timestamp - b.timestamp
    model.set '_messageIds', list.map ({ id }) -> id

    model.ref '_channel', channel
    model.refList '_messages', 'messages', '_messageIds'
    model.setNull '_user',
      nick: 'conner'
    page.render()

orca.ready (model) ->
  window.model = model

  messages = model.at '_messages'
  channel = model.at '_channel'
  user = model.at '_user'

  elInput = document.getElementById 'input'
  elMessages = document.getElementById 'messages'
  
  document.body.scrollTop = elMessages.offsetHeight
  elInput.focus()

  # toggleActions = document.getElementById 'toggleActions'
  # toggleActions.addEventListener 'click', (e) ->
  #   text = toggleActions.innerText
  #   if text is 'Hide actions'
  #     toggleActions.innerText = 'Show actions'
  #     messages.className = 'hide'
  #   else
  #     toggleActions.innerText = 'Hide actions'
  #     messages.className = ''

  exports.submit = (e) ->
    messages.push
      timestamp: Date.now()
      channel: channel.get().id
      from: user.get().nick
      type: 'message'
      message: elInput.value
      new: true
    elInput.value = ''

  model.on 'set', 'messages.*', (id, message) ->
    return if message.new
    m = messages.get()
    i = m.length
    i-- while m[i-1].timestamp > message.timestamp
    message.new = true
    messages.insert i, message

  model.on 'insert', '_messages', ->
    document.body.scrollTop = elMessages.offsetHeight
    
  model.on 'push', '_messages', ->
    document.body.scrollTop = elMessages.offsetHeight




