# WsPubSub

** Example application for my [blog post](http://pap.github.io/blog/2014/02/14/elixr-websockets-plus-mongo-plus-redis-2/) on the use of Elixir websockets + Redis PubSub **

You need Mongo and Redis running.

The application assumes the following default values


__Mongo:__

  * host: __127.0.0.1__
  * port: __27017__
  * database: __MyDb__
  * collection: __MyCollection__


__Redis:__
  * host: __127.0.0.1__
  * port: __6379__


You will find the elixir application in ws_pub_sub dir and i will soon finish an example bullet.js webpage at webpage dir


You can use `python -m SimpleHTTPServer` command to serve this webpage at `http://localhost:8000`
