derby = require 'derby'
moment = require 'moment'

orca = derby.createApp module

orca.view.make 'Title', '#{{_channel.id}}'

orca.view.make 'Body', """
  <button id='toggleActions'>Hide actions</button>
  <ul id='messages'>
    {#each _channel.messages}<app:message>{/}
  </ul>
"""

orca.view.make 'message', """
  <li class='{{type}}'>
    <span class='timestamp'>({{prettyDate(timestamp)}})</span>
    {{#if from}}<span class='from'>{{from}}</span>{{/}}
    {{message}}
"""

orca.view.fn 'prettyDate', (d) ->
  moment(d).format 'hh:mm:ss a'

orca.get '/:channel', (page, model, params) ->
  path = 'channels.' + params.channel
  model.subscribe path, (e, channel) ->
    model.ref '_channel', channel
    model.setNull '_channel.messages', []
    page.render()

orca.ready (model) ->

  toggleActions = document.getElementById 'toggleActions'
  messages = document.getElementById 'messages'

  toggleActions.addEventListener 'click', (e) ->
    text = toggleActions.innerText
    if text is 'Hide actions'
      toggleActions.innerText = 'Show actions'
      messages.className = 'hide'
    else
      toggleActions.innerText = 'Hide actions'
      messages.className = ''