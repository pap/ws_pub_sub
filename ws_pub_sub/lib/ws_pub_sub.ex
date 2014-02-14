defmodule WsPubSub do
  use Application.Behaviour

  def start(_type, _args) do
    # initialize cowboy
    setup_cowboy
    # Initializes the ETS to store connected users
    _table = ConnectionTable.init
    WsPubSub.Supervisor.start_link
  end

  defp setup_cowboy do
    my_dispatch = :cowboy_router.compile([
                    {:_, [{"/websocket", :buller_handler, [{:handler, WsHandler}]}]}
                  ])
    # NOTE: to listen in port 80 you probably need to run the app as sudo
    # for demo purpose i'll start in port 8088
    {:ok, _} = :cowboy.start_http(
                 :http,
                 100,
                 [{:port, 8088}],
                 [{:env, [{:dispatch, my_dispatch}]}]
               )
  end
end
