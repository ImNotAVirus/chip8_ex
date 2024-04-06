defmodule Chip8Ex.Components.RAM do
  @moduledoc """
  TODO: Documentation
  """

  @memory_size 0xFFF

  ## Public functions

  defdelegate read(mem, start, n), to: Chip8Ex.Binary
  defdelegate write(mem, start, bytes), to: Chip8Ex.Binary

  def size(), do: @memory_size
  def new(), do: String.duplicate(<<0>>, @memory_size)
end
