defmodule RedisPubSub do

  use GenServer.Behaviour
  use Exredis

  @server __MODULE__
  @redis_host '127.0.0.1'
  @redis_port 6379
  @name :pubsub_exredis_client
  @notification_channel "my_channel"
  defrecord State, client: nil, client_sub: nil

  def start_link do
    :gen_server.start_link({:local, @server}, __MODULE__, [], [])
  end

  def init(_options\\[]) do
    client_sub = Exredis.Sub.start(@redis_host, @redis_port)
    client = Exredis.start(@redis_host, @redis_port)
    # Register the PubSub client so it is accessible to publish connection
    # and disconnection notifications
    :global.register_name(@name, client)
    _pid = Kernel.self
    state = State[client: client, client_sub: client_sub]
    # NOTE: send() is defined in another module (MsgPusher)
    # the function is "registered" as the handler for any message arriving to
    # redis @notification_channel
    client_sub |>
      Exredis.Sub.subscribe "#{@notification_channel}", fn(msg) -> MsgPusher.send(msg) end
    {:ok, state}
  end

  def handle_call(_request, _from, state) do
    reply = _request
    {:reply, reply, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info(_info, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    # close redis connection
    client_sub = :erlang.list_to_pid(_state.client_sub)
    client_sub |> Exredis.Sub.stop
    client = :erlang.list_to_pid(_state.client)
    client |> Exredis.stop
    :ok
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
