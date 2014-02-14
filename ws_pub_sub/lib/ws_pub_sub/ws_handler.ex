defmodule WsHandler do

  @period 1000
  @redis_ws_in_chn "connected"
  @redis_ws_out_chn "disconnected"
  @db_host :'127.0.0.1'
  @db_port 27017
  @db_name :'MyDb'
  @db_collection :'MyCollection'

  defrecord State, guid: nil

  def init(_transport, req, _opts, _active) do
    _ = :erlang.send_after(@period, self, :refresh)
    {qs, req2} = :cowboy_req.qs(req)
    # Read the querystring from request
    state = State[guid: qs]
    # check if key exists
    connect(qs)
    {:ok, req2, state}
  end

  def stream("ping", req, state) do
    {:reply, "heartbeat message", req, state}
  end

  def stream(_data, req, state) do
    {:ok, req, state}
  end

  def info(:refresh, req, _state) do
    {:ok, req, _state}
  end

  def info({:broadcast, info}, req, state) do
    {:reply, info, req, state}
  end

  def info(_info, req, state) do
    {:ok, req, state}
  end

  def terminate(_req, _state) do
    disconnect(_state.guid)
    :ok
  end

  defp connect(key) do
    case mongo_auth(key) do
      :ok ->
        # Key exists. User is allowed to receive updates.
        ConnectionTable.insert(key, :erlang.pid_to_list(self))
        # Publish in Redis:
        # You can notify on a given channel that a user was added
        # to the connected users table
        :global.whereis_name(:pubsub_exredis_client)
          |> Exredis.Api.publish "#{@redis_ws_in_chn}", "#{key}"
      :not_found ->
        #TODO: notify user, log attempt etc...
    end
  end

  defp disconnect(key) do
    case  ConnectionTable.lookup(key) do
      {:ok, _} ->
        ConnectionTable.delete(key)
        # You can notify on a given channel that a user was removed
        # from the connected users table
        :global.whereis_name(:pubsub_exredis_client)
          |> Exredis.Api.publish "#{@redis_ws_out_chn}", "#{key}"
      _ ->
        # key does not exist
        # TODO: log ... etc...
    end
  end

  defp mongo_auth(key) do
    host = {@db_host, @db_port}
    # Connects and gets response ...
    # IMPORTANT: don't forget to close mongo connection !!!
    case :mongo.connect(host) do
      {:ok, conn} ->
        response = :mongo.do(
                     :safe,
                     :master,
                     conn,
                     @db_name,
                     fn -> :mongo.find_one(@db_collection, {:_id, key}) end
                   )
        case response do
          {:ok, {}} ->
            :mongo.disconnect(conn)
            :not_found
          {:ok, _} ->
            :mongo.disconnect(conn)
            :ok
          {:_, _} ->
            :mongo.disconnect(conn)
            :not_found
        end
      {:error,_} ->
          :not_found
    end
  end
end
