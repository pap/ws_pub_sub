defmodule MsgPusher do
  def send(msg) do
    case msg do
      {:message, _, _, _} ->
        {_,_,full_msg,_} = msg
        {_,parsed_msg} = JSEX.decode(full_msg)
        [msg_recipients | msg_data] = parsed_msg
        json_response = ExJSON.generate(msg_data)
        {_, recipients_list} = msg_recipients
        notify_connected_users(recipients_list, json_response)
      {:subscribed, _, _} ->
        # NOTE :subscribed is returned as the first message.
        # It is the ack message
    end
  end

  defp notify_connected_users(user_list, json_response) do
    :lists.foreach(fn(key) -> find_key(key, json_response) end, user_list)
  end

  defp find_key(key, json_response) do
    case ConnectionTable.lookup(key) do
          {:ok, pid } ->
            send(:erlang.list_to_pid(pid), {:broadcast, json_response})
          {:error, _} ->
    end
  end
end
