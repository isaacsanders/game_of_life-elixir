defmodule GameOfLifeTest do
  use ExUnit.Case

  test "neighboring_coordinates" do
    actual =
      {1, 1}
      |> GameOfLife.neighboring_coordinates()
      |> Enum.sort()

    assert [
             {0, 0},
             {0, 1},
             {0, 2},
             {1, 0},
             {1, 2},
             {2, 0},
             {2, 1},
             {2, 2}
           ] == actual

    assert {1, 1} not in actual
  end
end
