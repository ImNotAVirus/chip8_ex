defmodule Chip8Ex.Chip8Helper do
  @moduledoc """
  Some helpers for tests
  """

  alias Chip8Ex.VM

  ## Public API

  def roms_path() do
    Path.join(File.cwd!(), "test/roms")
  end

  def execute_rom(filename, cycles \\ 1000) do
    rom = File.read!(filename)
    vm = VM.new() |> VM.load_rom(rom)

    Enum.reduce(1..cycles, vm, fn _, vm ->
      VM.step(vm)
    end)
  end
end
