defmodule TestSuites.Chip8LogoTest do
  use Chip8Ex.Case

  ## Tests

  test "run the ROM", %{vm: vm} do
    filename = Path.join(roms_path(), "1-chip8-logo.ch8")
    vm = execute_rom(vm, filename, 39)
    screen = get_vm_display(vm)

    assert screen == expected_screen()
  end

  defp expected_screen() do
    [
      "                                                                ",
      "            xxxxx x                    x          xx            ",
      "              x     xx x   xx  xxx   xxx x  x  xx  x            ",
      "              x   x x x x x  x x  x x  x x  x x                 ",
      "              x   x x   x xxxx x  x x  x x  x  x                ",
      "              x   x x   x x    x  x x  x x  x   x               ",
      "              x   x x   x  xxx x  x  xxx  xxx xx                ",
      "                                                                ",
      "                                                                ",
      "           xxxxx   xx       xx  xxxxx           xxxxxxx         ",
      "          xxxxxxx xxx      xxx xxxxxxx         xxx   xxx        ",
      "         xxx   xx xxx      xxx xxx  xxx       xxx     xx        ",
      "        xxx       xxx          xxx   xx       xxx     xx        ",
      "        xxx  x x  xxx       xx xxx   xx       xxx     xx        ",
      "        xxx       xxxxxx   xxx xxx   xx        xxx   xx         ",
      "        xxx x   x xxxxxxx  xxx xxx   xx xxxx    xxxxxx          ",
      "        xxx  xxx  xxx  xxx xxx xxx  xxx xxxx   xxx  xxx         ",
      "        xxx       xxx   xx xxx xxxxxxx        xxx    xxx        ",
      "        xxx       xxx   xx xxx xxxxxx        xxx      xx        ",
      "        xxx       xxx   xx xxx xxx           xxx      xx        ",
      "        xxx       xxx   xx xxx xxx x x    x  xxx      xx        ",
      "         xxx   xx xxx   xx xxx xxx xxx   xx  xxxx    xxx        ",
      "          xxxxxxx xxx   xx xxx xxx   x    x   xxxxxxxxx         ",
      "           xxxxx  xxx   xx xxx xxx   x x xxx   xxxxxxx          ",
      "                                                                ",
      "                                                                ",
      "             xxx  xx   xx x       xx      x x    xx             ",
      "              x  x  x x   xxx    x   x  x   xxx x  x            ",
      "              x  xxxx  x  x       x  x  x x x   xxxx            ",
      "              x  x      x x        x x  x x x   x               ",
      "              x   xxx xx   xx    xx   xxx x  xx  xxx            ",
      "                                                                "
    ]
    |> Enum.join()
  end
end
