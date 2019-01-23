defmodule RedisPrint do
  def subscribe(host,port,channel) do
    {:ok, pubsub} = Redix.PubSub.start_link(host: host, port: port)
    {:ok, ref} = Redix.PubSub.subscribe(pubsub, channel, self())
    receive_messages(pubsub,ref)
  end

  def receive_messages(pubsub,ref) do
    receive do
      {:redix_pubsub, ^pubsub, ^ref, :message, %{channel: _, payload: payload}} ->
        :erlang.binary_to_term(payload) |> IO.inspect()
    end
    receive_messages(pubsub,ref)
  end
end
