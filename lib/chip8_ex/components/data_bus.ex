defmodule Chip8Ex.Components.DataBus do
  @moduledoc """
  TODO: Documentation
  """

  use Agent

  alias __MODULE__
  alias Chip8Ex.Components.{RAM, VRAM}

  defstruct memory: nil, vram: nil

  ## Public functions

  def start_link(opts) do
    Agent.start_link(
      fn ->
        %DataBus{
          memory: RAM.new(),
          vram: VRAM.new()
        }
      end,
      opts
    )
  end

  def read(agent, address, len) do
    Agent.get(agent, &do_read(&1, address, len))
  end

  def read!(agent, address, len) do
    case read(agent, address, len) do
      {:ok, value} -> value
      {:error, reason} -> raise reason
    end
  end

  def write(agent, address, bytes) do
    Agent.get_and_update(agent, &do_write(&1, address, bytes))
  end

  def write!(agent, address, bytes) do
    case write(agent, address, bytes) do
      :ok -> :ok
      {:error, reason} -> raise reason
    end
  end

  def vram_clear_screen(agent) do
    Agent.update(agent, &do_vram_clear_screen/1)
  end

  def vram_clear_screen!(agent) do
    :ok = vram_clear_screen(agent)
  end

  def vram_get_buffer(agent) do
    Agent.get(agent, &do_vram_get_buffer/1)
  end

  def vram_get_buffer!(agent) do
    {:ok, value} = vram_get_buffer(agent)
    value
  end

  def vram_set_buffer(agent, buffer) do
    Agent.update(agent, &do_vram_set_buffer(&1, buffer))
  end

  def vram_set_buffer!(agent, buffer) do
    :ok = vram_set_buffer(agent, buffer)
  end

  ## Private functions

  defp do_read(%DataBus{} = bus, address, len) do
    ram_area = 0..RAM.size()

    cond do
      address in ram_area and (address + len) in ram_area ->
        {:ok, RAM.read(bus.memory, address, len)}

      true ->
        begin_addy = Integer.to_string(address, 16)
        end_addy = Integer.to_string(address + len, 16)
        {:error, "unmapped area: 0x#{begin_addy}:0x#{end_addy}"}
    end
  end

  defp do_write(%DataBus{} = bus, address, bytes) do
    ram_area = 0..RAM.size()
    byte_size = byte_size(bytes)

    cond do
      address in ram_area and (address + byte_size) in ram_area ->
        {:ok, %DataBus{bus | memory: RAM.write(bus.memory, address, bytes)}}

      true ->
        begin_addy = Integer.to_string(address, 16)
        end_addy = Integer.to_string(address + byte_size, 16)
        {{:error, "unmapped area: 0x#{begin_addy}:0x#{end_addy}"}, bus}
    end
  end

  defp do_vram_clear_screen(%DataBus{} = bus) do
    %DataBus{bus | vram: VRAM.new()}
  end

  defp do_vram_get_buffer(%DataBus{} = bus) do
    {:ok, bus.vram}
  end

  defp do_vram_set_buffer(%DataBus{} = bus, buffer) do
    %DataBus{bus | vram: buffer}
  end
end
