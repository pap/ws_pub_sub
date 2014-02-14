# WsPubSub

** Example application for my [blog post](http://pap.github.io/) on the use of Elixir websockets + Redis PubSub **

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


The Elixir Application is at WsPubSub dir
An example webpage is at Webpage dir

You can use `python -m SimpleHTTPServer` command to serve this webpage at `http://localhost:8000`
