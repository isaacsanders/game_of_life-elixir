defmodule GameOfLife.Printer do
  def print([]) do
    :ok
  end

  def to_string([]) do
    ""
  end

  def to_string(board_state) do
    {:organism, {_x, top_row_num}, _status} =
      Enum.min_by(board_state, fn {:organism, {_x, y}, _status} -> y end)

    normalized =
      Enum.map(board_state, fn {:organism, {x, y}, status} ->
        {:organism, {x, y - top_row_num}, status}
      end)

    {:organism, {left_col_num, _y}, _status} =
      Enum.min_by(normalized, fn {:organism, {x, _y}, _status} -> x end)

    {:organism, {_x, bottom_row_num}, _status} =
      Enum.max_by(normalized, fn {:organism, {_x, y}, _status} -> y end)

    mapping = Enum.group_by(normalized, fn {:organism, {_x, y}, _status} -> y end)

    0..bottom_row_num
    |> Enum.map(fn a ->
      case Map.fetch(mapping, a) do
        {:ok, row} ->
          row_to_string(row, left_col_num)

        :error ->
          ""
      end
    end)
    |> Enum.join("\n")
  end

  def row_to_string(row, left_col_num) do
    normalized =
      row
      |> Enum.map(fn {:organism, {x, y}, status} ->
        {:organism, {x - left_col_num, y}, status}
      end)

    {:organism, {normalized_rightmost_x_in_row, _y}, _status} =
      Enum.max_by(normalized, fn {:organism, {x, _y}, _status} -> x end)

    mapping =
      normalized
      |> Enum.map(fn {:organism, {x, _y}, _status} = cell -> {x, cell} end)
      |> Map.new()

    0..normalized_rightmost_x_in_row
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
    <<0x29688::utf8>>
  end

  def cell_to_string({:organism, _coordintates, :dead}) do
    " "
  end
end
