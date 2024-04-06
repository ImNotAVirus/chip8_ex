defmodule TestSuites.CoraxPlusTest do
  use Chip8Ex.Case

  ## Tests

  test "run the ROM", %{vm: vm} do
    filename = Path.join(roms_path(), "3-corax+.ch8")
    vm = execute_rom(vm, filename)
    screen = get_vm_display(vm)

    assert screen == expected_screen()
  end

  defp expected_screen() do
    [
      "                                                                ",
      "  xxx x x         xxx x x         xxx x x         xxx xxx       ",
      "   xx  x   x x      x  x   x x    xxx xxx  x x    x   xx   x x  ",
      "    x x x  xx     xx  x x  xx     x x   x  xx     xx    x  xx   ",
      "  xxx x x  x      xxx x x  x      xxx   x  x      x   xx   x    ",
      "                                                                ",
      "  x x x x         xxx xxx         xxx xxx         xxx xxx       ",
      "  xxx  x   x x    x x xx   x x    xxx xx   x x    x    xx  x x  ",
      "    x x x  xx     x x x    xx     x x   x  xx     xx    x  xx   ",
      "    x x x  x      xxx xxx  x      xxx xx   x      x   xxx  x    ",
      "                                                                ",
      "  xxx x x         xxx xxx         xxx xxx         xxx xxx       ",
      "  xx   x   x x    xxx x x  x x    xxx   x  x x    x   xx   x x  ",
      "    x x x  xx     x x x x  xx     x x  x   xx     xx  x    xx   ",
      "  xx  x x  x      xxx xxx  x      xxx  x   x      x   xxx  x    ",
      "                                                                ",
      "  xxx x x         xxx xx          xxx  xx             x x       ",
      "    x  x   x x    xxx  x   x x    xxx x    x x    x x  x   x x  ",
      "   x  x x  xx     x x  x   xx     x x xxx  xx     x x x x  xx   ",
      "   x  x x  x      xxx xxx  x      xxx xxx  x       x  x x  x    ",
      "                                                                ",
      "  xxx x x         xxx xxx         xxx xxx                       ",
      "  xxx  x   x x    xxx   x  x x    xxx xx   x x                  ",
      "    x x x  xx     x x xx   xx     x x x    xx                   ",
      "  xx  x x  x      xxx xxx  x      xxx xxx  x                    ",
      "                                                                ",
      "  xx  x x         xxx xxx         xxx  xx             x x    x  ",
      "   x   x   x x    xxx  xx  x x    x   x    x x    x x xxx   xx  ",
      "   x  x x  xx     x x   x  xx     xx  xxx  xx     x x   x    x  ",
      "  xxx x x  x      xxx xxx  x      x   xxx  x       x    x x xxx ",
      "                                                                ",
      "                                                                "
    ]
    |> Enum.join()
  end
end
