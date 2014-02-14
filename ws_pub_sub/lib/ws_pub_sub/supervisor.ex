defmodule WsPubSub.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      # Redis pubsub module is supervised
      worker(RedisPubSub, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
