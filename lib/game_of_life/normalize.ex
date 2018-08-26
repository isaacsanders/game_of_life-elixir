defmodule GameOfLife.Normalize do
  def bounds(board_state) do
    Enum.reduce(board_state, nil, fn
      {x, y}, nil ->
        {x, y, x, y}

      {x, y}, {left, top, right, bottom} ->
        {min(left, x), min(top, y), max(right, x), max(bottom, y)}
    end)
  end

  def normalized(board_state) do
    normalized(board_state, bounds(board_state))
  end

  def normalized(board_state, {left_col_num, top_row_num, _right_col_num, _bottom_row_num}) do
    Enum.map(board_state, fn {x, y} ->
      {x - left_col_num, y - top_row_num}
    end)
  end
end
