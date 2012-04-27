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

  model.subscribe "channels.#{params.channel}", messageQuery, (e, channel) ->
    model.ref '_channel', channel
    model.refList '_messages', 'messages', '_messageIds'
    page.render()

orca.ready (model) ->
  window.model = model

  input = document.getElementById 'input'
  messages = document.getElementById 'messages'
  
  document.body.scrollTop = messages.offsetHeight
  input.focus()

  # toggleActions = document.getElementById 'toggleActions'
  # toggleActions.addEventListener 'click', (e) ->
  #   text = toggleActions.innerText
  #   if text is 'Hide actions'
  #     toggleActions.innerText = 'Show actions'
  #     messages.className = 'hide'
  #   else
  #     toggleActions.innerText = 'Hide actions'
  #     messages.className = ''

  model.on 'push', '_messages', (message, len, isLocal) ->
    document.body.scrollTop = messages.offsetHeight