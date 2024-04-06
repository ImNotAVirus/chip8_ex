defmodule TestSuites.FlagsTest do
  use Chip8Ex.Case

  ## Tests

  test "run the ROM", %{vm: vm} do
    filename = Path.join(roms_path(), "4-flags.ch8")
    vm = execute_rom(vm, filename)
    screen = get_vm_display(vm)

    assert screen == expected_screen()
  end

  defp expected_screen() do
    [
      "x x  x  xx  xx  x x   xx                    xxx                 ",
      "xxx x x x x x x x x    x   x x x x x x        x  x x x x x x    ",
      "x x xxx xx  xx   x     x   xx  xx  xx       xx   xx  xx  xx     ",
      "x x x x x   x    x    xxx  x   x   x        xxx  x   x   x      ",
      "                                                                ",
      "xxx                   x x                   xxx                 ",
      " xx  x x x x x x      xxx  x x x x x x x x  xx   x x x x x x x x",
      "  x  xx  xx  xx         x  xx  xx  xx  xx     x  xx   x  xx  xx ",
      "xxx  x   x   x          x  x   x   x   x    xx   x   x x x   x  ",
      "                                                                ",
      "xxx                   xxx                   xxx                 ",
      "x    x x x x x x        x  x x x x x x x x  xx   x x x x x x    ",
      "xxx  xx  xx  xx         x  xx   x  xx  xx   x    xx  xx  xx     ",
      "xxx  x   x   x          x  x   x x x   x    xxx  x   x   x      ",
      "                                                                ",
      "                                                                ",
      "xxx  x  xx  xx  x x   x x                   xxx                 ",
      "x   x x x x x x x x   xxx  x x x x x x x x  xx   x x x x x x x x",
      "x   xxx xx  xx   x      x  xx  xx  xx  xx     x  xx  xx  xx  xx ",
      "xxx x x x x x x  x      x  x   x   x   x    xx   x   x   x   x  ",
      "                                                                ",
      "xxx                   xxx                   xxx                 ",
      "x    x x x x x x        x  x x x x x x x x  xx   x x x x x x    ",
      "xxx  xx  xx  xx         x  xx  xx  xx  xx   x    xx  xx  xx     ",
      "xxx  x   x   x          x  x   x   x   x    xxx  x   x   x      ",
      "                                                                ",
      "                                                                ",
      "xxx xxx x x xxx xx    xxx xxx                         x x    x  ",
      "x x  x  xxx xx  x x   x   xx   x x x x            x x xxx   xx  ",
      "x x  x  x x x   xx    xx  x    xx  xx             x x   x    x  ",
      "xxx  x  x x xxx x x   x   xxx  x   x               x    x x xxx ",
      "                                                                "
    ]
    |> Enum.join()
  end
end
