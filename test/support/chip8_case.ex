defmodule Chip8Ex.Case do
  @moduledoc """
  Some helpers for tests
  """

  use ExUnit.CaseTemplate

  alias Chip8Ex.VM
  alias Chip8Ex.Components.DataBus

  ## Setup

  using do
    quote do
      import unquote(__MODULE__),
        only: [
          roms_path: 0,
          execute_rom: 2,
          execute_rom: 3,
          get_vm_display: 1
        ]
    end
  end

  setup do
    keyboard = start_supervised!(Chip8Ex.KeyboardFake)
    bus = start_supervised!({Chip8Ex.Components.DataBus, [keyboard: keyboard]})

    %{
      keyboard: keyboard,
      bus: bus,
      vm: VM.new(bus)
    }
  end

  ## Public API

  def roms_path() do
    Path.join(File.cwd!(), "test/roms")
  end

  def execute_rom(vm, filename, cycles \\ 1000) do
    vm = VM.load_rom(vm, File.read!(filename))

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
