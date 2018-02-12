defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Memory.GameBackup.load(name) || Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("guess", %{"place" => i, "status" => s, "reset" => r}, socket) do
    IO.inspect(socket.assigns[:game])
    # game = Game.guess(socket.assigns[:game], i)
    # IO.inspect(game)
    # Memory.GameBackup.save(socket.assigns[:name], game)
    # socket = assign(socket, :game, game)
    # if s == true do
    #   if Game.client_view(game).game1.hideOrnot == false do
    #     {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    #   else
    #     #discussed with ceng zeng
    #     {:reply, {:hide, %{ "game" => Game.client_view(game)}}, socket}
    #   end
    #
    #
    # else
    #   {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}

    if r == true do
        game = Game.new()
        Memory.GameBackup.save(socket.assigns[:name], game)
        socket = assign(socket, :game, game)
        {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    else
        game = Game.guess(socket.assigns[:game], i)
        IO.inspect(game)
        Memory.GameBackup.save(socket.assigns[:name], game)
        socket = assign(socket, :game, game)
        if s == true do
          if Game.client_view(game).game1.hideOrnot == false do
            {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
          else
            #discussed with ceng zeng
            {:reply, {:hide, %{ "game" => Game.client_view(game)}}, socket}
          end


        else
          {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    end



    end

  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
