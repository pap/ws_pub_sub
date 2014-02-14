defmodule WsPubSub.Mixfile do
  use Mix.Project

  def project do
    [ app: :ws_pub_sub,
      version: "0.0.1",
      elixir: "~> 0.12.4",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { WsPubSub, [] },
      applications: [
        :crypto,
        :compiler,
        :syntax_tools,
        :cowlib,
        :ranch,
        :cowboy,
        :bullet,
        :eredis,
        :bson,
        :mongodb,
        :exredis,
        :exjson,
        :jsex,
        :jsx
      ]
    ]
  end

  defp deps do
    [
      { :exredis, github: "artemeff/exredis" },
      { :jsex,    github: "talentdeficit/jsex" },
      { :exjson,  github: "guedes/exjson" },
      { :bullet,  github: "extend/bullet" },
      { :mongodb, github: "mururu/mongodb-erlang" },
      { :relex,   github: "yrashk/relex" }
    ]
  end
end
