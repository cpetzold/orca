var simple = require('derby').createApp(module)
  , moment = require('moment')
  , view = simple.view
  , get = simple.get;

view.fn('prettyDate', function(d) {
  return moment(d).format('h:mm:ss a');
});

view.make('message', '<li>({{prettyDate(timestamp)}}) ({{from}}) {{message}}');

view.make('Body', '<ul>{#each messages}<app:message>{/}</ul>');

get('/', function(page, model) {
  model.subscribe('messages', function() {
    page.render();
  });
});