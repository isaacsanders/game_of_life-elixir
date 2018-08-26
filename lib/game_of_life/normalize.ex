defmodule GameOfLife.Normalize do
  def bounds(board_state) do
    {:organism, {left_col_num, _y}, _status} =
      Enum.min_by(board_state, fn {:organism, {x, _y}, _status} -> x end)

    {:organism, {_x, top_row_num}, _status} =
      Enum.min_by(board_state, fn {:organism, {_x, y}, _status} -> y end)

    {:organism, {right_col_num, _y}, _status} =
      Enum.max_by(board_state, fn {:organism, {x, _y}, _status} -> x end)

    {:organism, {_x, bottom_row_num}, _status} =
      Enum.max_by(board_state, fn {:organism, {_x, y}, _status} -> y end)

    {left_col_num, top_row_num, right_col_num, bottom_row_num}
  end

  def normalized(board_state) do
    normalized(board_state, bounds(board_state))
  end

  def normalized(board_state, {left_col_num, top_row_num, _right_col_num, _bottom_row_num}) do
    Enum.map(board_state, fn {:organism, {x, y}, status} ->
      {:organism, {x - left_col_num, y - top_row_num}, status}
    end)
  end
end
