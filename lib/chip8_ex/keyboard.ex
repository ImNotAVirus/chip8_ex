defmodule Chip8Ex.Keyboard do
  @moduledoc """
  TODO: Documentation
  """

  ## Behaviour defs

  @callback key_pressed?(keyboard, id) :: boolean()
            when keyboard: atom() | pid(), id: 0x0..0xF
end
