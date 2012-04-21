var express = require('express')
  , neigh = require('../../')
  , simple = require('./simple')
  , server = express.createServer()
      .use(express.static(__dirname + '/public'))
      .use(simple.router());

var store = simple.createStore({ listen: server })
  , bot = neigh.createBot({ store: store, debug: true });

server.listen(3000);