defmodule Chip8Ex.Display do
  @moduledoc """
  TODO: Chip8Ex.Display
  """

  @width 64
  @height 32

  ## Behaviour defs

  @callback new() :: display when display: any()
  @callback clear(display) :: any() when display: any()
  @callback set_cursor(display, x, y) :: any() when display: any(), x: integer(), y: integer()
  @callback on(display) :: any() when display: any()
  @callback off(display) :: any() when display: any()

  ## Public API

  def width(), do: @width
  def height(), do: @height

  def on(display, x, y) do
    set_cursor(display, x, y)
    on(display)
    set_cursor(display, 0, @height)
  end

  def off(display, x, y) do
    set_cursor(display, x, y)
    off(display)
    set_cursor(display, 0, @height)
  end

  def new() do
    display = backend().new()
    backend().clear(display)
    display
  end

  def clear(display), do: backend().clear(display)
  def set_cursor(display, x, y), do: backend().set_cursor(display, x, y)
  def on(display), do: backend().on(display)
  def off(display), do: backend().off(display)

  ## Private functions

  defp backend(), do: Application.get_env(:chip8_ex, :display_driver, Chip8Ex.Components.ConsoleDisplay)
end
