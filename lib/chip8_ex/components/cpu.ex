defmodule Chip8Ex.Components.CPU do
  @moduledoc """
  TODO: Documentation
  """

  import Bitwise, only: [bor: 2, band: 2, bxor: 2, bsl: 2, bsr: 2]

  alias __MODULE__
  alias Chip8Ex.Binary
  alias Chip8Ex.Components.DataBus

  defstruct pc: nil,
            # Generally used to store memory addresses (16 bits)
            i: nil,
            # General purpose 8-bit registers, VF is the flag register
            reg: %{},
            # Delay timer register
            dt: nil,
            # Sound timer register
            st: nil,
            # Stack should be on the DataBus but I'll keep on the CPU state
            # because it's easier and there is no offical location for the stack
            stack: [],
            # Data bus (RAM, VRAM, keyboard)
            bus: nil,
            arch: :chip8

  @flag_reg 0xF
  @archs [:chip8, :super_chip, :xo_chip]

  ## Public functions

  def new(data_bus) do
    %CPU{
      pc: 0,
      i: 0,
      reg: for(x <- 0x0..0xF, into: %{}, do: {x, 0}),
      dt: 0,
      st: 0,
      bus: data_bus
    }
  end

  def set_architecture(%CPU{} = cpu, arch) when arch in @archs do
    %CPU{cpu | arch: arch}
  end

  def next(%CPU{} = cpu) do
    instruction = DataBus.read!(cpu.bus, cpu.pc, 2)
    new_cpu = execute(%CPU{cpu | pc: cpu.pc + 2}, instruction)

    %CPU{new_cpu | dt: max(cpu.dt, 0), st: max(cpu.st, 0)}
  end

  ## Instructions

  # 00E0 - CLS
  def execute(%CPU{} = cpu, <<0x00::4, 0x0E0::12>>) do
    :ok = DataBus.vram_clear_screen!(cpu.bus)
    cpu
  end

  # 00EE - RET
  def execute(%CPU{} = cpu, <<0x00::4, 0x0EE::12>>) do
    [ret | remaining] = cpu.stack
    %CPU{cpu | pc: ret, stack: remaining}
  end

  # 0nnn - SYS addr
  def execute(%CPU{} = cpu, <<0x00::4, _addr::12>>) do
    # This instruction is only used on the old computers on which Chip-8
    # was originally implemented. It is ignored by modern interpreters.
    cpu
  end

  # 1nnn - JP addr
  def execute(%CPU{} = cpu, <<0x01::4, addr::12>>) do
    %CPU{cpu | pc: addr}
  end

  # 2nnn - CALL addr
  def execute(%CPU{} = cpu, <<0x02::4, addr::12>>) do
    if length(cpu.stack) >= 16, do: raise("stack full")
    %CPU{cpu | pc: addr, stack: [cpu.pc | cpu.stack]}
  end

  # 3xkk - SE Vx, byte
  def execute(%CPU{} = cpu, <<0x03::4, x::4, kk::8>>) do
    case cpu.reg[x] == kk do
      true -> %CPU{cpu | pc: cpu.pc + 2}
      false -> cpu
    end
  end

  # 4xkk - SNE Vx, byte
  def execute(%CPU{} = cpu, <<0x04::4, x::4, kk::8>>) do
    case cpu.reg[x] == kk do
      true -> cpu
      false -> %CPU{cpu | pc: cpu.pc + 2}
    end
  end

  # 5xy0 - SE Vx, Vy
  def execute(%CPU{} = cpu, <<0x05::4, x::4, y::4, 0::4>>) do
    case cpu.reg[x] == cpu.reg[y] do
      true -> %CPU{cpu | pc: cpu.pc + 2}
      false -> cpu
    end
  end

  # 6xkk - LD Vx, byte
  def execute(%CPU{} = cpu, <<0x06::4, x::4, kk::8>>) do
    %CPU{cpu | reg: Map.put(cpu.reg, x, kk)}
  end

  # 7xkk - ADD Vx, byte
  def execute(%CPU{} = cpu, <<0x07::4, x::4, kk::8>>) do
    %CPU{cpu | reg: Map.update!(cpu.reg, x, &band(&1 + kk, 0xFF))}
  end

  # 8xy0 - LD Vx, Vy
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 0::4>>) do
    %CPU{cpu | reg: Map.put(cpu.reg, x, cpu.reg[y])}
  end

  # 8xy1 - OR Vx, Vy
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 1::4>>) do
    new_reg = Map.update!(cpu.reg, x, &bor(&1, cpu.reg[y]))

    new_reg =
      case cpu.arch do
        :chip8 -> Map.replace!(new_reg, @flag_reg, 0)
        :super_chip -> new_reg
        :xo_chip -> new_reg
      end

    %CPU{cpu | reg: new_reg}
  end

  # 8xy2 - AND Vx, Vy
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 2::4>>) do
    new_reg = Map.update!(cpu.reg, x, &band(&1, cpu.reg[y]))

    new_reg =
      case cpu.arch do
        :chip8 -> Map.replace!(new_reg, @flag_reg, 0)
        :super_chip -> new_reg
        :xo_chip -> new_reg
      end

    %CPU{cpu | reg: new_reg}
  end

  # 8xy3 - XOR Vx, Vy
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 3::4>>) do
    new_reg = Map.update!(cpu.reg, x, &bxor(&1, cpu.reg[y]))

    new_reg =
      case cpu.arch do
        :chip8 -> Map.replace!(new_reg, @flag_reg, 0)
        :super_chip -> new_reg
        :xo_chip -> new_reg
      end

    %CPU{cpu | reg: new_reg}
  end

  # 8xy4 - ADD Vx, Vy
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 4::4>>) do
    result = cpu.reg[x] + cpu.reg[y]
    vf = if result > 0xFF, do: 0x1, else: 0x0

    reg =
      cpu.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(@flag_reg, vf)

    %CPU{cpu | reg: reg}
  end

  # 8xy5 - SUB Vx, Vy
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 5::4>>) do
    result = cpu.reg[x] - cpu.reg[y]
    vf = if cpu.reg[x] > cpu.reg[y], do: 0x1, else: 0x0

    reg =
      cpu.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(@flag_reg, vf)

    %CPU{cpu | reg: reg}
  end

  # 8xy6 - SHR Vx {, Vy}
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 6::4>>) do
    src =
      case cpu.arch do
        :chip8 -> cpu.reg[y]
        :super_chip -> cpu.reg[x]
        :xo_chip -> cpu.reg[y]
      end

    result = bsr(src, 1)
    vf = if band(cpu.reg[x], 0b00000001) == 0x0, do: 0x0, else: 0x1

    reg =
      cpu.reg
      |> Map.put(x, result)
      |> Map.put(@flag_reg, vf)

    %CPU{cpu | reg: reg}
  end

  # 8xy7 - SUBN Vx, Vy
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 7::4>>) do
    result = cpu.reg[y] - cpu.reg[x]
    vf = if cpu.reg[y] > cpu.reg[x], do: 0x1, else: 0x0

    reg =
      cpu.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(@flag_reg, vf)

    %CPU{cpu | reg: reg}
  end

  # 8xyE - SHL Vx {, Vy}
  def execute(%CPU{} = cpu, <<0x08::4, x::4, y::4, 0xE::4>>) do
    src =
      case cpu.arch do
        :chip8 -> cpu.reg[y]
        :super_chip -> cpu.reg[x]
        :xo_chip -> cpu.reg[y]
      end

    result = bsl(src, 1)
    vf = if band(cpu.reg[x], 0b10000000) == 0x0, do: 0x0, else: 0x1

    reg =
      cpu.reg
      |> Map.put(x, band(result, 0xFF))
      |> Map.put(@flag_reg, vf)

    %CPU{cpu | reg: reg}
  end

  # 9xy0 - SNE Vx, Vy
  def execute(%CPU{} = cpu, <<0x09::4, x::4, y::4, 0::4>>) do
    case cpu.reg[x] == cpu.reg[y] do
      true -> cpu
      false -> %CPU{cpu | pc: cpu.pc + 2}
    end
  end

  # Annn - LD I, addr
  def execute(%CPU{} = cpu, <<0x0A::4, addr::12>>) do
    %CPU{cpu | i: addr}
  end

  # Bnnn - JP V0, addr
  def execute(%CPU{} = cpu, <<0x0B::4, addr::12>>) do
    add =
      case cpu.arch do
        :chip8 -> cpu.reg[0x0]
        :super_chip -> cpu.reg[bsr(addr, 8)]
        :xo_chip -> cpu.reg[0x0]
      end

    %CPU{cpu | pc: addr + add}
  end

  # Cxkk - RND Vx, byte
  def execute(%CPU{} = cpu, <<0x0C::4, x::4, kk::8>>) do
    rand = Enum.random(0x00..0xFF)
    %CPU{cpu | reg: Map.put(cpu.reg, x, band(rand, kk))}
  end

  # Dxyn - DRW Vx, Vy, nibble
  def execute(%CPU{} = cpu, <<0x0D::4, x::4, y::4, n::4>>) do
    # FIXME: CPU should not have a direct access to the Display
    # Find a way to use the data bus
    x = rem(cpu.reg[x], Chip8Ex.Display.width())
    y = rem(cpu.reg[y], Chip8Ex.Display.height())

    data = DataBus.read!(cpu.bus, cpu.i, n)
    bits = for <<chunk::1 <- data>>, do: chunk

    bits_with_pos =
      bits
      |> Enum.with_index()
      |> Enum.map(fn {bit, index} ->
        {bit, {rem(index, 8), div(index, 8)}}
      end)

    ## Display
    buffer = DataBus.vram_get_buffer!(cpu.bus)

    {new_buffer, vf} =
      Enum.reduce(bits_with_pos, {buffer, 0}, fn {bit, {off_x, off_y}}, {buffer, vf} ->
        # FIXME: CPU should not have a direct access to the Display
        {pos_x, pos_y} =
          case cpu.arch do
            :chip8 ->
              {x + off_x, y + off_y}

            :super_chip ->
              {x + off_x, y + off_y}

            :xo_chip ->
              {rem(x + off_x, Chip8Ex.Display.width()), rem(y + off_y, Chip8Ex.Display.height())}
          end

        if pos_x in 0..(Chip8Ex.Display.width() - 1) and
             pos_y in 0..(Chip8Ex.Display.height() - 1) do
          bin_pos = pos_y * Chip8Ex.Display.width() + pos_x

          curr = :binary.at(buffer, bin_pos)
          new_buffer = Binary.write_byte(buffer, bin_pos, bxor(curr, bit))

          new_vf = if curr == 1 and bit == 1, do: 1, else: 0
          {new_buffer, max(vf, new_vf)}
        else
          {buffer, vf}
        end
      end)

    :ok = DataBus.vram_set_buffer!(cpu.bus, new_buffer)

    %CPU{cpu | reg: Map.put(cpu.reg, @flag_reg, vf)}
  end

  # Ex9E - SKP Vx
  def execute(%CPU{} = cpu, <<0x0E::4, x::4, 0x9E::8>>) do
    case DataBus.key_pressed?(cpu.bus, cpu.reg[x]) do
      true -> %CPU{cpu | pc: cpu.pc + 2}
      false -> cpu
    end
  end

  # ExA1 - SKNP Vx
  def execute(%CPU{} = cpu, <<0x0E::4, x::4, 0xA1::8>>) do
    case DataBus.key_pressed?(cpu.bus, cpu.reg[x]) do
      true -> cpu
      false -> %CPU{cpu | pc: cpu.pc + 2}
    end
  end

  # Fx07 - LD Vx, DT
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x07::8>>) do
    %CPU{cpu | reg: Map.put(cpu.reg, x, cpu.dt)}
  end

  # Fx0A - LD Vx, K
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x0A::8>>) do
    key_pressed = Enum.find(0x0..0xF, &DataBus.key_pressed?(cpu.bus, &1))

    case key_pressed do
      # Loop until a key is pressed
      nil -> %CPU{cpu | pc: cpu.pc - 2}
      key -> %CPU{cpu | reg: Map.put(cpu.reg, x, key)}
    end
  end

  # Fx15 - LD DT, Vx
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x15::8>>) do
    %CPU{cpu | dt: cpu.reg[x]}
  end

  # Fx18 - LD ST, Vx
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x18::8>>) do
    %CPU{cpu | st: cpu.reg[x]}
  end

  # Fx1E - ADD I, Vx
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x1E::8>>) do
    %CPU{cpu | i: cpu.i + cpu.reg[x]}
  end

  # Fx29 - LD F, Vx
  # TODO: ...
  # Set I = location of sprite for digit Vx.
  # The value of I is set to the location for the hexadecimal sprite corresponding to the value of Vx. See section 2.4, Display, for more information on the Chip-8 hexadecimal font.

  # Fx33 - LD B, Vx
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x33::8>>) do
    vx = cpu.reg[x]
    c = div(vx, 100)
    d = vx |> div(10) |> rem(10)
    u = rem(vx, 10)

    :ok = DataBus.write!(cpu.bus, cpu.i, <<c, d, u>>)
    cpu
  end

  # Fx55 - LD [I], Vx
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x55::8>>) do
    bytes =
      0..x
      |> Enum.map(&cpu.reg[&1])
      |> :binary.list_to_bin()

    :ok = DataBus.write!(cpu.bus, cpu.i, bytes)

    case cpu.arch do
      :chip8 -> %CPU{cpu | i: cpu.i + x + 1}
      :super_chip -> cpu
      :xo_chip -> %CPU{cpu | i: cpu.i + x + 1}
    end
  end

  # Fx65 - LD Vx, [I]
  def execute(%CPU{} = cpu, <<0x0F::4, x::4, 0x65::8>>) do
    new_cpu =
      cpu.bus
      |> DataBus.read!(cpu.i, x + 1)
      |> :binary.bin_to_list()
      |> Enum.with_index()
      |> Enum.reduce(cpu, fn {byte, index}, cpu ->
        %CPU{cpu | reg: Map.put(cpu.reg, index, byte)}
      end)

    case new_cpu.arch do
      :chip8 -> %CPU{new_cpu | i: new_cpu.i + x + 1}
      :super_chip -> new_cpu
      :xo_chip -> %CPU{new_cpu | i: new_cpu.i + x + 1}
    end
  end

  def execute(%CPU{} = _cpu, <<instruction::16>>) do
    value =
      instruction
      |> Integer.to_string(16)
      |> String.pad_leading(4, "0")

    raise "unknown instruction 0x#{value}"
  end
end
