defmodule Chip8Ex.Chip8Helper do
  @moduledoc """
  Some helpers for tests
  """

  import ExUnit.Callbacks, only: [start_supervised!: 1]

  alias Chip8Ex.VM
  alias Chip8Ex.Components.DataBus

  ## Public API

  def roms_path() do
    Path.join(File.cwd!(), "test/roms")
  end

  def execute_rom(filename, cycles \\ 1000) do
    rom = File.read!(filename)
    bus = start_supervised!(Chip8Ex.Components.DataBus)

    vm = VM.new(bus) |> VM.load_rom(rom)

    Enum.reduce(1..cycles, vm, fn _, vm ->
      VM.step(vm)
    end)
  end

  def get_vm_display(vm) do
    buffer = DataBus.vram_get_buffer!(vm.bus)

    for <<byte <- buffer>>, into: <<>> do
      if byte == 0, do: " ", else: "x"
    end
  end
end
