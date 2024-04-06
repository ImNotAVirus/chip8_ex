defmodule Chip8Ex.Components.VRAM do
  @moduledoc """
  TODO: Documentation
  """

  alias Chip8Ex.Display

  @memory_size Display.width() * Display.height()

  ## Public functions

  defdelegate read(mem, start, n), to: Chip8Ex.Binary
  defdelegate write(mem, start, bytes), to: Chip8Ex.Binary

  def size(), do: @memory_size
  def new(), do: String.duplicate(<<0>>, @memory_size)
end
