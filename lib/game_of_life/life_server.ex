defmodule GameOfLife.LifeServer do
  import GameOfLife.Organism
  use GenServer

  @type init_opt ::
          GenServer.option()
          | {:initial_state, [GameOfLife.Organism.coordinates()]}

  defstruct life_board: nil

  def start(opts) do
    GenServer.start(__MODULE__, opts, opts)
  end

  def init(opts) do
    life_board =
      :ets.new(GameOfLife.LifeServer.Board, [
        :set,
        :private,
        read_concurrency: true
      ])

    initial_state =
      opts
      |> Keyword.get(:initial_state, [])
      |> Enum.map(fn {x, y} -> {{x, y}, []} end)

    :ets.insert_new(life_board, initial_state)

    {:ok, struct(__MODULE__, life_board: life_board)}
  end

  def handle_call(:tick, _from, server) do
    current_generation =
      server.life_board
      |> :ets.tab2list()
      |> MapSet.new(fn {coordinates, []} -> coordinates end)

    :ets.init_table(server.life_board, fn :read ->
      next_generation =
        current_generation
        |> Stream.flat_map(fn coordinates ->
          coordinates
          |> GameOfLife.neighboring_coordinates()
          |> Enum.map(&{&1, coordinates})
        end)
        |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
        |> Enum.flat_map(fn {coordinates, neighbors} ->
          alive_neighbors = length(neighbors)

          if MapSet.member?(current_generation, coordinates) do
            next_gen_cell_flat_mapper(coordinates, :alive, alive_neighbors)
          else
            next_gen_cell_flat_mapper(coordinates, :dead, alive_neighbors)
          end
        end)
        |> Enum.map(&{&1, []})

      {next_generation, fn _ -> :end_of_input end}
    end)

    {:reply,
     server.life_board
     |> :ets.tab2list()
     |> Enum.map(&elem(&1, 0)), server}
  end

  def next_gen_cell_flat_mapper(coordinates, :alive, 3), do: [coordinates]

  def next_gen_cell_flat_mapper(coordinates, :alive, 2), do: [coordinates]

  def next_gen_cell_flat_mapper(_coordinates, :alive, _), do: []

  def next_gen_cell_flat_mapper(_coordinates, :dead, 0), do: []

  def next_gen_cell_flat_mapper(coordinates, :dead, 3), do: [coordinates]

  def next_gen_cell_flat_mapper(_coordinates, :dead, _), do: []
end
