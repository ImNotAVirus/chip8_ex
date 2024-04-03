defmodule TestSuites.CoraxPlusTest do
  use ExUnit.Case

  import Chip8Ex.Chip8Helper

  alias Chip8Ex.DisplayAgent

  ## Tests

  test "run the ROM" do
    filename = Path.join(roms_path(), "3-corax+.ch8")
    cpu = execute_rom(filename)
    screen = DisplayAgent.get_screen(cpu.display)

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
      "  xx  x x         xxx xxx         xxx  xx             x x   xxx ",
      "   x   x   x x    xxx  xx  x x    x   x    x x    x x xxx   x x ",
      "   x  x x  xx     x x   x  xx     xx  xxx  xx     x x   x   x x ",
      "  xxx x x  x      xxx xxx  x      x   xxx  x       x    x x xxx ",
      "                                                                ",
      "                                                                "
    ]
    |> Enum.join("\n")
  end
end
