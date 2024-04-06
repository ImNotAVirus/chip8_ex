defmodule Chip8Ex.VM do
  @moduledoc """
  TODO: Chip8Ex.VM
  """

  alias __MODULE__
  alias Chip8Ex.Components.{CPU, DataBus}

  @entry_addr 0x200

  defstruct cpu: nil, bus: nil

  ## Public API

  def new(data_bus) do
    %VM{
      cpu: CPU.new(data_bus),
      bus: data_bus
    }
  end

  def load_rom(%VM{} = vm, rom) when is_binary(rom) do
    :ok = DataBus.write!(vm.bus, @entry_addr, rom)
    %VM{vm | cpu: %CPU{vm.cpu | pc: @entry_addr}}
  end

  def step(%VM{} = vm) do
    %VM{vm | cpu: CPU.next(vm.cpu)}
  end
end
