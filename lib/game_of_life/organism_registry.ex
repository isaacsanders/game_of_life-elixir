defmodule GameOfLife.OrganismRegistry do
  def name(x, y) do
    {:via, Registry, {__MODULE__, {x, y}}}
  end

  def name({x, y}) do
    {:via, Registry, {__MODULE__, {x, y}}}
  end
end
