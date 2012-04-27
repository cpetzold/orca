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
    page.render()

orca.ready (model) ->
  window.model = model

  messages = model.at '_messages'

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

  model.on 'set', 'messages.*', (id, message) ->
    return if message.new
    m = messages.get()
    i = m.length
    i-- while m[i-1].timestamp > message.timestamp
    message.new = true
    messages.insert i, message
    

  model.on 'insert', '_messages', (message, len) ->
    document.body.scrollTop = elMessages.offsetHeight