defmodule TestSuites.QuirksTest do
  use Chip8Ex.Case

  alias Chip8Ex.{KeyboardFake, VM}

  ## Tests

  test "rom with CHIP-8 architecture", %{vm: vm, keyboard: keyboard} do
    # Setup VM/Keyboard
    vm = VM.set_architecture(vm, :chip8)
    :ok = KeyboardFake.put_keys(keyboard, [1])

    # Test
    filename = Path.join(roms_path(), "5-quirks.ch8")
    vm = execute_rom(vm, filename, 5000)
    screen = get_vm_display(vm)

    assert screen == expected_chip8_screen()
  end

  test "rom with SUPER-CHIP modern architecture", %{vm: vm, bus: bus} do
    # Setup VM/Keyboard
    vm = VM.set_architecture(vm, :super_chip)
    :ok = Chip8Ex.Components.DataBus.write(bus, 0x1FF, <<2>>)

    # Test
    filename = Path.join(roms_path(), "5-quirks.ch8")
    vm = execute_rom(vm, filename, 5000)
    screen = get_vm_display(vm)

    assert screen == expected_super_chip_screen()
  end

  test "rom with SUPER-CHIP legacy architecture", %{vm: vm, bus: bus} do
    # Setup VM/Keyboard
    vm = VM.set_architecture(vm, :super_chip)
    :ok = Chip8Ex.Components.DataBus.write(bus, 0x1FF, <<4>>)

    # Test
    filename = Path.join(roms_path(), "5-quirks.ch8")
    vm = execute_rom(vm, filename, 5000)
    screen = get_vm_display(vm)

    File.write(
      "aa.txt",
      for(<<line::binary-64 <- screen>>, do: "\"#{line}\",") |> Enum.join("\n")
    )

    assert screen == expected_super_chip_screen()
  end

  test "rom with XO-CHIP architecture", %{vm: vm, keyboard: keyboard} do
    # Setup VM/Keyboard
    vm = VM.set_architecture(vm, :xo_chip)
    :ok = KeyboardFake.put_keys(keyboard, [3])

    # Test
    filename = Path.join(roms_path(), "5-quirks.ch8")
    vm = execute_rom(vm, filename, 5000)
    screen = get_vm_display(vm)

    assert screen == expected_xo_chip_screen()
  end

  ## Private functions

  defp expected_chip8_screen() do
    # FIXME: display wait doesn't pass here
    [
      "                                                                ",
      " x x xxx     xx  xxx  xx xxx xxx          xxx xx                ",
      " x x x       x x xx  xx  xx   x           x x x x          x x  ",
      " x x xx      xx  x     x x    x           x x x x          xx   ",
      "  x  x       x x xxx xx  xxx  x           xxx x x          x    ",
      "                                                                ",
      " xxx xxx xxx xxx xx  x x                  xxx xx                ",
      " xxx xx  xxx x x x x x x                  x x x x          x x  ",
      " x x x   x x x x xx   x                   x x x x          xx   ",
      " x x xxx x x xxx x x  x                   xxx x x          x    ",
      "                                                                ",
      " xx  xxx  xx xx      x x  x  xxx xxx       xx x   xxx x x       ",
      " x x  x  xx  x x     x x x x  x   x       xx  x   x x x x  x x  ",
      " x x  x    x xx      xxx xxx  x   x         x x   x x xxx   x   ",
      " xx  xxx xx  x    x  xxx x x xxx  x       xx  xxx xxx xxx  x x  ",
      "                                                                ",
      " xxx x   xxx xx  xx  xxx xx   xx          xxx xx                ",
      " x   x    x  x x x x  x  x x x            x x x x          x x  ",
      " x   x    x  xx  xx   x  x x x x          x x x x          xx   ",
      " xxx xxx xxx x   x   xxx x x  xx          xxx x x          x    ",
      "                                                                ",
      "  xx x x xxx xxx xxx xxx xx   xx          xxx xxx xxx           ",
      " xx  xxx  x  x    x   x  x x x            x x x   x        x x  ",
      "   x x x  x  xx   x   x  x x x x          x x xx  xx       xx   ",
      " xx  x x xxx x    x  xxx x x  xx          xxx x   x        x    ",
      "                                                                ",
      "  xx x x xxx xx  xxx xx   xx              xxx xxx xxx           ",
      "   x x x xxx x x  x  x x x                x x x   x        x x  ",
      "   x x x x x xx   x  x x x x              x x xx  xx       xx   ",
      " xx   xx x x x   xxx x x  xx              xxx x   x        x    ",
      "                                                                ",
      "                                                                "
    ]
    |> Enum.join()
  end

  defp expected_super_chip_screen() do
    # FIXME: display wait doesn't pass here
    [
      "                                                                ",
      " x x xxx     xx  xxx  xx xxx xxx          xxx xxx xxx           ",
      " x x x       x x xx  xx  xx   x           x x x   x        x x  ",
      " x x xx      xx  x     x x    x           x x xx  xx       xx   ",
      "  x  x       x x xxx xx  xxx  x           xxx x   x        x    ",
      "                                                                ",
      " xxx xxx xxx xxx xx  x x                  xxx xxx xxx           ",
      " xxx xx  xxx x x x x x x                  x x x   x        x x  ",
      " x x x   x x x x xx   x                   x x xx  xx       xx   ",
      " x x xxx x x xxx x x  x                   xxx x   x        x    ",
      "                                                                ",
      " xx  xxx  xx xx      x x  x  xxx xxx       xx x   xxx x x       ",
      " x x  x  xx  x x     x x x x  x   x       xx  x   x x x x  x x  ",
      " x x  x    x xx      xxx xxx  x   x         x x   x x xxx   x   ",
      " xx  xxx xx  x    x  xxx x x xxx  x       xx  xxx xxx xxx  x x  ",
      "                                                                ",
      " xxx x   xxx xx  xx  xxx xx   xx          xx  xxx xxx x x       ",
      " x   x    x  x x x x  x  x x x            xxx x x  x  xxx  x x  ",
      " x   x    x  xx  xx   x  x x x x          x x x x  x  x x  xx   ",
      " xxx xxx xxx x   x   xxx x x  xx          xxx xxx  x  x x  x    ",
      "                                                                ",
      "  xx x x xxx xxx xxx xxx xx   xx          xxx xx                ",
      " xx  xxx  x  x    x   x  x x x            x x x x          x x  ",
      "   x x x  x  xx   x   x  x x x x          x x x x          xx   ",
      " xx  x x xxx x    x  xxx x x  xx          xxx x x          x    ",
      "                                                                ",
      "  xx x x xxx xx  xxx xx   xx              xxx xx                ",
      "   x x x xxx x x  x  x x x                x x x x          x x  ",
      "   x x x x x xx   x  x x x x              x x x x          xx   ",
      " xx   xx x x x   xxx x x  xx              xxx x x          x    ",
      "                                                                ",
      "                                                                "
    ]
    |> Enum.join()
  end

  defp expected_xo_chip_screen() do
    # FIXME: display wait doesn't pass here
    [
      "                                                                ",
      " x x xxx     xx  xxx  xx xxx xxx          xxx xxx xxx           ",
      " x x x       x x xx  xx  xx   x           x x x   x        x x  ",
      " x x xx      xx  x     x x    x           x x xx  xx       xx   ",
      "  x  x       x x xxx xx  xxx  x           xxx x   x        x    ",
      "                                                                ",
      " xxx xxx xxx xxx xx  x x                  xxx xx                ",
      " xxx xx  xxx x x x x x x                  x x x x          x x  ",
      " x x x   x x x x xx   x                   x x x x          xx   ",
      " x x xxx x x xxx x x  x                   xxx x x          x    ",
      "                                                                ",
      " xx  xxx  xx xx      x x  x  xxx xxx       xx x   xxx x x       ",
      " x x  x  xx  x x     x x x x  x   x       xx  x   x x x x  x x  ",
      " x x  x    x xx      xxx xxx  x   x         x x   x x xxx   x   ",
      " xx  xxx xx  x    x  xxx x x xxx  x       xx  xxx xxx xxx  x x  ",
      "                                                                ",
      " xxx x   xxx xx  xx  xxx xx   xx          xx  xxx xx  xxx       ",
      " x   x    x  x x x x  x  x x x            x x x x x x xx   x x  ",
      " x   x    x  xx  xx   x  x x x x          x x x x x x x    xx   ",
      " xxx xxx xxx x   x   xxx x x  xx          x x xxx x x xxx  x    ",
      "                                                                ",
      "  xx x x xxx xxx xxx xxx xx   xx          xxx xxx xxx           ",
      " xx  xxx  x  x    x   x  x x x            x x x   x        x x  ",
      "   x x x  x  xx   x   x  x x x x          x x xx  xx       xx   ",
      " xx  x x xxx x    x  xxx x x  xx          xxx x   x        x    ",
      "                                                                ",
      "  xx x x xxx xx  xxx xx   xx              xxx xxx xxx           ",
      "   x x x xxx x x  x  x x x                x x x   x        x x  ",
      "   x x x x x xx   x  x x x x              x x xx  xx       xx   ",
      " xx   xx x x x   xxx x x  xx              xxx x   x        x    ",
      "                                                                ",
      "                                                                "
    ]
    |> Enum.join()
  end
end
