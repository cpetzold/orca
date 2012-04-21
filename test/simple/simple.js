var derby = require('derby')
  , simple = derby.createApp(module)
  , moment = require('moment')
  , view = simple.view
  , get = simple.get;

view.make('Title', '#{{_channel.id}}');

view.make('Body', '<button id="toggleActions">Hide actions</button><ul id="messages">{#each _channel.messages}<app:message>{/}</ul>');

view.make('message',
  ['<li class="{{type}}">'
  , '<span class="timestamp">({{prettyDate(timestamp)}})</span> '
  , '{{#if from}}<span class="from">{{from}}</span> {{/}}'
  , '{{message}}'].join(''));

view.fn('prettyDate', function(d) {
  return moment(d).format('hh:mm:ss a');
});

get('/:channel', function(page, model, params) {
  var path = 'channels.' + params.channel;
  model.subscribe(path, function(e, channel) {
    model.ref('_channel', channel);
    model.setNull('_channel.messages', []);

    page.render();
  });
});

simple.ready(function(model) {

  var toggleActions = document.getElementById('toggleActions')
    , messages = document.getElementById('messages');

  toggleActions.addEventListener('click', function(e) {
    var text = toggleActions.innerText;
    if (text == 'Hide actions') {
      toggleActions.innerText = 'Show actions';
      messages.className = 'hide';
    } else {
      toggleActions.innerText = 'Hide actions';
      messages.className = '';
    }
  });

});