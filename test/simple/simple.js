var simple = require('derby').createApp(module)
  , view = simple.view
  , get = simple.get;

view.make('message', '<li><strong>{{from}}:</strong> {{message}}');

view.make('Body', '<ul>{#each messages}<app:message>{/}</ul>');

get('/', function(page, model) {
  model.subscribe('messages', function() {
    page.render();
  });
});