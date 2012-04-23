var derby = require('derby')
  , express = require('express')
  , orca = require('../../')
  , simple = require('./simple')
  , server = express.createServer()
      .use(express.favicon())
      .use(express.static(__dirname + '/public'))
      .use(express.static(orca.assets))
      .use(simple.router())
      .use(orca.router());

console.log(orca);

derby.use(require('racer-db-mongo'));

var store = simple.createStore({
    listen: server
  , db: { type: 'Mongo', uri: 'mongodb://localhost/orca' }
});

var bot = orca.createBot({
    store: store
  // , debug: true 
});

server.listen(3000);