defmodule GameOfLife do
  @moduledoc """
  GameOfLife keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @neighborhood_range -1..1

  def neighboring_coordinates({x, y}) do
    for dx <- @neighborhood_range,
        dy <- @neighborhood_range,
        {dx, dy} != {0, 0} do
      {x + dx, y + dy}
    end
  end
end
