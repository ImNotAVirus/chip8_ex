defmodule Chip8Ex.DisplayAgent do
  @moduledoc false

  use Agent

  import ExUnit.Callbacks, only: [start_supervised!: 1]

  alias Chip8Ex.{Binary, Display}

  @behaviour Chip8Ex.Display

  @width Chip8Ex.Display.width()
  @height Chip8Ex.Display.height()

  ## Public API

  def start_link(_) do
    Agent.start_link(fn ->
      %{
        cursor: {0, 0},
        binary: String.duplicate(" ", @width * @height)
      }
    end)
  end

  def get_screen(display) do
    display
    |> Agent.get(& &1.binary)
    |> String.graphemes()
    |> Enum.chunk_every(@width)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  ## Behaviours

  @impl Chip8Ex.Display
  def new() do
    start_supervised!(__MODULE__)
  end

  @impl Chip8Ex.Display
  def clear(display) do
    Agent.update(display, fn state ->
      %{state | binary: String.duplicate(" ", @width * @height)}
    end)
  end

  @impl Chip8Ex.Display
  def set_cursor(display, x, y) do
    Agent.update(display, fn state ->
      %{state | cursor: {x, y}}
    end)
  end

  @impl Chip8Ex.Display
  def on(display) do
    Agent.update(display, fn state ->
      {x, y} = state.cursor
      pos = y * Display.width() + x
      %{state | binary: Binary.write_byte(state.binary, pos, ?x)}
    end)
  end

  @impl Chip8Ex.Display
  def off(display) do
    Agent.update(display, fn state ->
      {x, y} = state.cursor
      pos = y * Display.width() + x
      %{state | binary: Binary.write_byte(state.binary, pos, ?\s)}
    end)
  end
end
