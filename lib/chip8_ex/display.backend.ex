defmodule Chip8Ex.Display.Backend do
  @moduledoc """
  TODO: Chip8Ex.Display.Backend
  """

  @behaviour Chip8Ex.Display

  ## Behaviour impl

  @impl true
  def new() do
    {}
  end

  @impl true
  def clear(_display) do
    IO.write("\e[2J")
  end

  @impl true
  def set_cursor(_display, x, y) do
    IO.write("\e[#{y + 1};#{x + 1}H")
  end

  @impl true
  def on(_display) do
    IO.write("█")
  end

  @impl true
  def off(_display) do
    IO.write(" ")
  end
end
