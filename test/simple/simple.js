var derby = require('derby')
  , simple = derby.createApp(module);

simple.get('/', function(page, model, params) {
  page.render();
});