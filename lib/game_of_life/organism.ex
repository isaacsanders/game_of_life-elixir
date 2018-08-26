defmodule GameOfLife.Organism do
  require Record

  Record.defrecord(:organism, [:coordinates, :status])

  @type coordinates :: {integer(), integer()}
  @type status :: :alive
  @type organism :: {:organism, coordinates(), status()}
  @type board_state :: [organism()]
end
