defmodule Chip8Ex.VM do
  @moduledoc """
  TODO: Chip8Ex.VM
  """

  import Bitwise, only: [bor: 2, band: 2, bxor: 2, bsl: 2, bsr: 2]

  alias __MODULE__
  alias Chip8Ex.Binary

  @memory_size 0xFFF
  @entry_addr 0x200

  defstruct pc: 0, i: 0, reg: %{}, timers: %{}, mem: [], stack: nil, display: nil

  ## Public API

  def new() do
    %VM{
      mem: List.duplicate(0, @memory_size),
      reg: for(x <- 0x0..0xF, into: %{}, do: {x, 0}),
      timers: %{dt: 0, st: 0},
      stack: :queue.new(),
      display: Chip8Ex.Display.new()
    }
  end

  def load_rom(%VM{} = vm, rom) do
    suffix_size = @memory_size - @entry_addr - byte_size(rom)

    %__MODULE__{
      vm
      | pc: @entry_addr,
        mem: String.duplicate(<<0>>, @entry_addr) <> rom <> String.duplicate(<<0>>, suffix_size)
    }
  end

  def step(%VM{} = vm) do
    <<opcode::4, args::bitstring-12>> = Binary.read(vm.mem, vm.pc, 2)
    new_vm = %VM{vm | pc: vm.pc + 2}

    vm = do_step(new_vm, opcode, args)

    %VM{vm| timers: %{dt: max(vm.timers.dt, 0), st: max(vm.timers.st, 0)}}
  end

  ## Instructions

  # 00E0 - CLS
  defp do_step(vm, 0x00, <<0x0E0::12>>) do
    Chip8Ex.Display.clear(vm.display)
    vm
  end

  # 00EE - RET
  defp do_step(vm, 0x00, <<0x0EE::12>>) do
    {{:value, ret}, stack} = :queue.out_r(vm.stack)
    %VM{vm | pc: ret, stack: stack}
  end

  # 0nnn - SYS addr
  defp do_step(vm, 0x00, <<_addr::12>>) do
    # This instruction is only used on the old computers on which Chip-8
    # was originally implemented. It is ignored by modern interpreters.
    vm
  end

  # 1nnn - JP addr
  defp do_step(vm, 0x01, <<addr::12>>) do
    %VM{vm | pc: addr}
  end

  # 2nnn - CALL addr
  defp do_step(vm, 0x02, <<addr::12>>) do
    stack = :queue.in(vm.pc, vm.stack)
    %VM{vm | pc: addr, stack: stack}
  end

  # 3xkk - SE Vx, byte
  defp do_step(vm, 0x03, <<x::4, kk::8>>) do
    case vm.reg[x] == kk do
      true -> %VM{vm | pc: vm.pc + 2}
      false -> vm
    end
  end

  # 4xkk - SNE Vx, byte
  defp do_step(vm, 0x04, <<x::4, kk::8>>) do
    case vm.reg[x] == kk do
      true -> vm
      false -> %VM{vm | pc: vm.pc + 2}
    end
  end

  # 5xy0 - SE Vx, Vy
  defp do_step(vm, 0x05, <<x::4, y::4, 0::4>>) do
    case vm.reg[x] == vm.reg[y] do
      true -> %VM{vm | pc: vm.pc + 2}
      false -> vm
    end
  end

  # 6xkk - LD Vx, byte
  defp do_step(vm, 0x06, <<x::4, kk::8>>) do
    %VM{vm | reg: Map.put(vm.reg, x, kk)}
  end

  # 7xkk - ADD Vx, byte
  defp do_step(vm, 0x07, <<x::4, kk::8>>) do
    %VM{vm | reg: Map.update!(vm.reg, x, &band(&1 + kk, 0xFF))}
  end

  # 8xy0 - LD Vx, Vy
  defp do_step(vm, 0x08, <<x::4, y::4, 0::4>>) do
    %VM{vm | reg: Map.put(vm.reg, x, vm.reg[y])}
  end

  # 8xy1 - OR Vx, Vy
  defp do_step(vm, 0x08, <<x::4, y::4, 1::4>>) do
    %VM{vm | reg: Map.update!(vm.reg, x, &bor(&1, vm.reg[y]))}
  end

  # 8xy2 - AND Vx, Vy
  defp do_step(vm, 0x08, <<x::4, y::4, 2::4>>) do
    %VM{vm | reg: Map.update!(vm.reg, x, &band(&1, vm.reg[y]))}
  end

  # 8xy3 - XOR Vx, Vy
  defp do_step(vm, 0x08, <<x::4, y::4, 3::4>>) do
    %VM{vm | reg: Map.update!(vm.reg, x, &bxor(&1, vm.reg[y]))}
  end

  # 8xy4 - ADD Vx, Vy
  defp do_step(vm, 0x08, <<x::4, y::4, 4::4>>) do
    result = vm.reg[x] + vm.reg[y]
    vf = if result > 0xFF, do: 0x1, else: 0x0

    reg =
      vm.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(0xF, vf)

    %VM{vm | reg: reg}
  end

  # 8xy5 - SUB Vx, Vy
  defp do_step(vm, 0x08, <<x::4, y::4, 5::4>>) do
    result = vm.reg[x] - vm.reg[y]
    vf = if vm.reg[x] > vm.reg[y], do: 0x1, else: 0x0

    reg =
      vm.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(0xF, vf)

    %VM{vm | reg: reg}
  end

  # 8xy6 - SHR Vx {, Vy}
  defp do_step(vm, 0x08, <<x::4, _y::4, 6::4>>) do
    # NOTE: (Optional, or configurable) Set VX to the value of VY
    result = bsr(vm.reg[x], 1)
    vf = if band(vm.reg[x], 0b00000001) == 0x0, do: 0x0, else: 0x1

    reg =
      vm.reg
      |> Map.put(x, result)
      |> Map.put(0xF, vf)

    %VM{vm | reg: reg}
  end

  # 8xy7 - SUBN Vx, Vy
  defp do_step(vm, 0x08, <<x::4, y::4, 7::4>>) do
    result = vm.reg[y] - vm.reg[x]
    vf = if vm.reg[y] > vm.reg[x], do: 0x1, else: 0x0

    reg =
      vm.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(0xF, vf)

    %VM{vm | reg: reg}
  end

  # 8xyE - SHL Vx {, Vy}
  defp do_step(vm, 0x08, <<x::4, _y::4, 0xE::4>>) do
    # NOTE: (Optional, or configurable) Set VX to the value of VY
    result = bsl(vm.reg[x], 1)
    vf = if band(vm.reg[x], 0b10000000) == 0x0, do: 0x0, else: 0x1

    reg =
      vm.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(0xF, vf)

    %VM{vm | reg: reg}
  end

  # 9xy0 - SNE Vx, Vy
  defp do_step(vm, 0x09, <<x::4, y::4, 0::4>>) do
    case vm.reg[x] == vm.reg[y] do
      true -> vm
      false -> %VM{vm | pc: vm.pc + 2}
    end
  end

  # Annn - LD I, addr
  defp do_step(vm, 0x0A, <<addr::12>>) do
    %VM{vm | i: addr}
  end

  # Bnnn - JP V0, addr
  # TODO: ...
  # Jump to location nnn + V0.
  # TODO: The program counter is set to nnn plus the value of V0.

  # Cxkk - RND Vx, byte
  # TODO: ...
  # Set Vx = random byte AND kk.
  # The interpreter generates a random number from 0 to 255, which is then ANDed with the value kk. The results are stored in Vx. See instruction 8xy2 for more information on AND.

  # Dxyn - DRW Vx, Vy, nibble
  defp do_step(vm, 0x0D, <<x::4, y::4, n::4>>) do
    x = rem(vm.reg[x], Chip8Ex.Display.width())
    y = rem(vm.reg[y], Chip8Ex.Display.height())

    # TODO: Set vf on collision
    vf = 0

    data = Binary.read(vm.mem, vm.i, n)
    bits = for <<chunk::1 <- data>>, do: chunk

    bits_with_pos =
      bits
      |> Enum.with_index()
      |> Enum.map(fn {bit, index} ->
        {bit, {rem(index, 8), div(index, 8)}}
      end)

    ## Display
    Enum.each(bits_with_pos, fn {bit, {off_x, off_y}} ->
      if bit == 0x1, do: Chip8Ex.Display.on(vm.display, x + off_x, y + off_y)
    end)

    %VM{vm | reg: Map.put(vm.reg, 0xF, vf)}
  end

  # Ex9E - SKP Vx
  # TODO:
  # Skip next instruction if key with the value of Vx is pressed.
  # Checks the keyboard, and if the key corresponding to the value of Vx is currently in the down position, PC is increased by 2.

  # ExA1 - SKNP Vx
  # TODO:
  # Skip next instruction if key with the value of Vx is not pressed.
  # Checks the keyboard, and if the key corresponding to the value of Vx is currently in the up position, PC is increased by 2.

  # Fx07 - LD Vx, DT
  defp do_step(vm, 0x0F, <<x::4, 0x07::8>>) do
    %VM{vm | reg: Map.put(vm.reg, x, vm.timers[:dt])}
  end

  # Fx0A - LD Vx, K
  # TODO: ...
  # Wait for a key press, store the value of the key in Vx.
  # All execution stops until a key is pressed, then the value of that key is stored in Vx.

  # Fx15 - LD DT, Vx
  defp do_step(vm, 0x0F, <<x::4, 0x15::8>>) do
    %VM{vm | timers: Map.put(vm.timers, :timers, vm.reg[x])}
  end

  # Fx18 - LD ST, Vx
  # TODO: ...
  # Set sound timer = Vx.
  # ST is set equal to the value of Vx.

  # Fx1E - ADD I, Vx
  defp do_step(vm, 0x0F, <<x::4, 0x1E::8>>) do
    %VM{vm | i: vm.i + vm.reg[x]}
  end

  # Fx29 - LD F, Vx
  # TODO: ...
  # Set I = location of sprite for digit Vx.
  # The value of I is set to the location for the hexadecimal sprite corresponding to the value of Vx. See section 2.4, Display, for more information on the Chip-8 hexadecimal font.

  # Fx33 - LD B, Vx
  defp do_step(vm, 0x0F, <<x::4, 0x33::8>>) do
    vx = vm.reg[x]
    c = div(vx, 100)
    d = vx |> div(10) |> rem(10)
    u = rem(vx, 10)

    Map.update!(vm, :mem, &Binary.write(&1, vm.i, <<c, d, u>>))
  end

  # Fx55 - LD [I], Vx
  defp do_step(vm, 0x0F, <<x::4, 0x55::8>>) do
    Enum.reduce(0..x, vm, fn i, vm ->
      %VM{vm | mem: Binary.write_byte(vm.mem, vm.i + i, vm.reg[i])}
    end)
  end

  # Fx65 - LD Vx, [I]
  defp do_step(vm, 0x0F, <<x::4, 0x65::8>>) do
    Enum.reduce(0..x, vm, fn i, vm ->
      %VM{vm | reg: Map.put(vm.reg, i, Binary.read_byte(vm.mem, vm.i + i))}
    end)
  end

  defp do_step(_vm, opcode, <<operand::12>>) do
    full = bsl(opcode, 12) + operand
    raise "unknown opcode #{Integer.to_string(full, 16)}"
  end
end
