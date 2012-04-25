derby = require 'derby'
moment = require 'moment'

orca = derby.createApp module

orca.view.fn 'prettyDate', (d) ->
  moment(d).format 'hh:mm:ss a'

orca.get '/:channel', (page, model, params) ->
  path = 'channels.' + params.channel
  model.subscribe path, (e, channel) ->
    model.ref '_channel', channel
    model.setNull '_channel.messages', []
    page.render()

orca.ready (model) ->

  input = document.getElementById 'input'
  messages = document.getElementById 'messages'
  # toggleActions = document.getElementById 'toggleActions'

  document.body.scrollTop = messages.offsetHeight
  input.focus()

  # toggleActions.addEventListener 'click', (e) ->
  #   text = toggleActions.innerText
  #   if text is 'Hide actions'
  #     toggleActions.innerText = 'Show actions'
  #     messages.className = 'hide'
  #   else
  #     toggleActions.innerText = 'Hide actions'
  #     messages.className = ''

  model.on 'push', '_channel.messages', (message, len, isLocal) ->
    document.body.scrollTop = messages.offsetHeight