defmodule GameOfLife.Printer do
  def print([]) do
    :ok
  end

  def to_string([]) do
    ""
  end

  def to_string(board_state) do
    {left, top, right, bottom} = bounds = GameOfLife.Normalize.bounds(board_state)
    normalized = GameOfLife.Normalize.normalized(board_state, bounds)

    mapping = Enum.group_by(normalized, fn {:organism, {_x, y}, _status} -> y end)

    0..(bottom - top)
    |> Enum.map(fn a ->
      case Map.fetch(mapping, a) do
        {:ok, row} ->
          row_to_string(row, left, right)

        :error ->
          ""
      end
    end)
    |> Enum.join("\n")
  end

  def row_to_string(row, left, right) do
    mapping =
      row
      |> Enum.map(fn {:organism, {x, _y}, _status} = cell -> {x, cell} end)
      |> Map.new()

    0..(right - left)
    |> Enum.map(fn a ->
      case Map.fetch(mapping, a) do
        {:ok, cell} ->
          cell_to_string(cell)

        :error ->
          " "
      end
    end)
    |> Enum.join()
  end

  def cell_to_string({:organism, _coordintates, :alive}) do
    "0"
  end

  def cell_to_string({:organism, _coordintates, :dead}) do
    " "
  end
end
