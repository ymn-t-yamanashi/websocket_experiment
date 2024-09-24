defmodule WebsocketExperimentWeb.RoomChannel do
  use WebsocketExperimentWeb, :channel

  intercept ["user_joined"]

  @impl true
  def join("room:lobby", payload, socket) do
    IO.inspect("------------- room:lobby -------------")
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    IO.inspect("------------- new_msg -------------")
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # def handle_in(argl, map, _socket) do
  #   IO.inspect("--argl----------------------")
  #   IO.inspect(argl)
  #   IO.inspect("--map----------------------")
  #   IO.inspect(map)
  # end

  # def handle_out("user_joined", msg, socket) do
  #   if Accounts.ignoring_user?(socket.assigns[:user], msg.user_id) do
  #     {:noreply, socket}
  #   else
  #     push(socket, "user_joined", msg)
  #     {:noreply, socket}
  #   end
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
