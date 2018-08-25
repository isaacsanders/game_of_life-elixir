defmodule GameOfLife.Examples do
  def blinker do
    [{0, 1}, {1, 1}, {2, 1}]
  end

  def toad do
    [
      {1, 0},
      {2, 0},
      {3, 0},
      {0, 1},
      {1, 1},
      {2, 1}
    ]
  end

  def glider do
    [
      {1, 0},
      {2, 1},
      {0, 2},
      {1, 2},
      {2, 2}
    ]
  end
end
