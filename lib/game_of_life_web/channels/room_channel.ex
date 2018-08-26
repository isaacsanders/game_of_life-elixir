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

    {:ok, assign(socket, :life_server, life_server)}
  end

  def handle_in("initial", %{"initial_state" => rle_contents}, socket) do
    with {:ok, tokens, line_count} <- :rle_lexer.string(to_charlist(rle_contents)),
         {:ok, initial_state} <- :rle_parser.parse(tokens),
         {:ok, life_server} <- GameOfLife.LifeServer.start(initial_state: initial_state) do
      board_state = Enum.map(initial_state, &{:organism, &1, :alive})
      {left, top, right, bottom} = bounds = GameOfLife.Normalize.bounds(board_state)

      reply =
        board_state
        |> GameOfLife.Normalize.normalized(bounds)
        |> Enum.map(fn {:organism, {x, y}, :alive} ->
          %{x: x, y: y}
        end)

      {:reply,
       {:ok,
        %{
          bounds: %{
            left: left,
            top: top,
            right: right,
            bottom: bottom
          },
          board_state: reply
        }}, assign(socket, :life_server, life_server)}
    end
  end

  def handle_in("tick", _params, socket) do
    live_cells =
      socket.assigns[:life_server]
      |> GenServer.call(:tick)
      |> Enum.filter(fn {:organism, _coordinates, status} -> status == :alive end)

    {left, top, right, bottom} = bounds = GameOfLife.Normalize.bounds(live_cells)

    reply =
      live_cells
      |> GameOfLife.Normalize.normalized(bounds)
      |> Enum.map(fn {:organism, {x, y}, :alive} ->
        %{x: x, y: y}
      end)

    {:reply,
     {:ok,
      %{
        bounds: %{
          left: left,
          top: top,
          right: right,
          bottom: bottom
        },
        board_state: reply
      }}, socket}
  end

  def terminate(reason, socket) do
    GenServer.stop(socket.assigns[:life_server])
    :ok
  end
end
