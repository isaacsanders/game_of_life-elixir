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
        keypos: 2,
        read_concurrency: true
      ])

    initial_state =
      opts
      |> Keyword.get(:initial_state, [])
      |> Enum.map(fn coordinates ->
        organism(coordinates: coordinates, status: :alive)
      end)

    :ets.insert_new(life_board, initial_state)

    {:ok, struct(__MODULE__, life_board: life_board)}
  end

  def handle_call(:tick, _from, server) do
    board_state =
      server.life_board
      |> :ets.tab2list()
      |> Enum.map(fn organism(coordinates: coordinates) = cell ->
        {coordinates, cell}
      end)
      |> Map.new()

    :ets.init_table(server.life_board, fn :read ->
      new_members =
        board_state
        |> Map.values()
        |> Stream.flat_map(fn organism(coordinates: coordinates) = cell ->
          coordinates
          |> GameOfLife.neighboring_coordinates()
          |> Enum.map(fn neighboring_coordinates ->
            {neighboring_coordinates, cell}
          end)
        end)
        |> Enum.group_by(
          fn {coordinates, _neighbor} ->
            coordinates
          end,
          fn {_coordinates, neighbor} -> neighbor end
        )
        |> Stream.flat_map(fn {coordinates, neighbors} ->
          alive_neighbors =
            neighbors
            |> Enum.filter(&(organism(&1, :status) == :alive))
            |> length

          case Map.fetch(board_state, coordinates) do
            {:ok, organism(status: :alive)} ->
              next_gen_cell_flat_mapper(coordinates, :alive, alive_neighbors)

            :error ->
              next_gen_cell_flat_mapper(coordinates, :dead, alive_neighbors)
          end
        end)
        |> Enum.to_list()

      {new_members, fn _ -> :end_of_input end}
    end)

    {:reply, :ets.tab2list(server.life_board), server}
  end

  def next_gen_cell_flat_mapper(coordinates, :alive, 3),
    do: [organism(coordinates: coordinates, status: :alive)]

  def next_gen_cell_flat_mapper(coordinates, :alive, 2),
    do: [organism(coordinates: coordinates, status: :alive)]

  def next_gen_cell_flat_mapper(coordinates, :alive, _), do: []

  def next_gen_cell_flat_mapper(_coordinates, :dead, 0), do: []

  def next_gen_cell_flat_mapper(coordinates, :dead, 3),
    do: [organism(coordinates: coordinates, status: :alive)]

  def next_gen_cell_flat_mapper(coordinates, :dead, _), do: []
end
