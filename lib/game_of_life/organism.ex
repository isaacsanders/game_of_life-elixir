defmodule GameOfLife.Organism do
  use GenServer

  defstruct coordinates: nil

  def start_link({x, y} = coordinates) do
    GenServer.start_link(__MODULE__, coordinates, name: GameOfLife.OrganismRegistry.name(x, y))
  end

  def init(coordinates) do
    neighbor_names =
      coordinates
      |> GameOfLife.neighboring_coordinates()
      |> Enum.map(fn coordinates ->
        GameOfLife.OrganismRegistry.name(coordinates)
      end)

    neighbor_pids =
      neighbor_names
      |> Enum.map(fn name ->
        GenServer.whereis(name)
      end)
      |> Enum.reject(&is_nil/1)

    cond do
      length(neighbor_pids) == 3 ->
        live_neighbors =
          neighbor_pids
          |> Enum.map(fn pid ->
            {Process.monitor(pid), pid}
          end)
          |> Map.new()

        {:ok, struct(__MODULE__, coordinates: coordinates, live_neighbors: live_neighbors)}

      true ->
        :ignore
    end
  end

  def handle_info({:DOWN, ref, :process, object, reason}, state) do
    live_neighbors = MapSet.delete(state.live_neighbors, ref)
    live_neighbor_count = MapSet.size(live_neighbors)

    cond do
      live_neighbor_count > 3 ->
        {:stop, {:shutdown, :overpopulation}, state}

      live_neighbor_count < 2 ->
        {:stop, {:shutdown, :underpopulation}, state}

      true ->
        {:noreply, %{state | live_neighbors: live_neighbors}}
    end
  end

  def neighbor_names({x, y}) do
  end
end
