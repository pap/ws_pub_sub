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

If you want to see some JSON getting into your browser open redis
console (`redis-cli`) and enter `PUBLISH "my_channel" "{\"recipients\":[\"00721b2a-046c-4ecc-a5df-5f808cc6c58f\"],\"data\":{\"entry\":{\"id\xe2\x80\x9d:\xe2\x80\x9d123\xe2\x80\x9d,\xe2\x80\x9dcomments\":0,\"tags\":0}}}"`
