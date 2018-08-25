defmodule GameOfLifeWeb.RoomChannel do
  use GameOfLifeWeb, :channel

  def join("game_of_life", params, socket) do
    {:ok, life_server} =
      params
      |> Map.update("initial_state", [], fn initial_state ->
        initial_state
        |> Enum.map(fn coordinates ->
          {Map.fetch!(coordinates, "x"), Map.fetch!(coordinates, "y")}
        end)
      end)
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> GameOfLife.LifeServer.start()

    socket =
      socket
      |> assign(:life_server, life_server)

    {:ok, socket}
  end

  def handle_in("tick", _params, socket) do
    reply =
      socket.assigns[:life_server]
      |> GenServer.call(:tick)
      |> GameOfLife.Printer.to_string()

    {:reply, {:ok, %{board_state: reply}}, socket}
  end

  def terminate(reason, socket) do
    GenServer.stop(socket.assigns[:life_server])
    :ok
  end
end
