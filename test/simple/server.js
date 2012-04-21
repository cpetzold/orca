var derby = require('derby')
  , express = require('express')
  , neigh = require('../../')
  , simple = require('./simple')
  , server = express.createServer()
      .use(express.favicon())
      .use(express.static(__dirname + '/public'))
      .use(simple.router());

derby.use(require('racer-db-mongo'));

var store = simple.createStore({
    listen: server
  , db: { type: 'Mongo', uri: 'mongodb://localhost/neigh' }
});

var bot = neigh.createBot({
    store: store
  // , debug: true 
});

server.listen(3000);