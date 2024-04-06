defmodule Chip8Ex.KeyboardFake do
  @moduledoc """
  TODO: Documentation
  """

  use Agent

  @behaviour Chip8Ex.Keyboard

  ## Public functions

  def start_link(_opts) do
    Agent.start_link(fn -> [] end)
  end

  def put_keys(agent, keys) do
    Agent.update(agent, fn _ -> keys end)
  end

  ## Keyboard behaviour

  @impl true
  def key_pressed?(agent, key) do
    Agent.get_and_update(agent, fn keys ->
      case keys do
        [^key | remaining] -> {true, remaining}
        _ -> {false, keys}
      end
    end)
  end
end
