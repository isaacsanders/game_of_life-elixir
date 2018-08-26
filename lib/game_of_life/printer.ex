defmodule GameOfLife.Printer do
  def to_string([]) do
    ""
  end

  def to_string(board_state) do
    {left, top, right, bottom} = bounds = GameOfLife.Normalize.bounds(board_state)
    normalized = GameOfLife.Normalize.normalized(board_state, bounds)

    mapping = Enum.group_by(normalized, fn {_x, y} -> y end)

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
    mapping = MapSet.new(row, fn {x, _y} -> x end)

    0..(right - left)
    |> Enum.map(fn a ->
      if MapSet.member?(mapping, a) do
        "0"
      else
        " "
      end
    end)
    |> Enum.join()
  end
end
