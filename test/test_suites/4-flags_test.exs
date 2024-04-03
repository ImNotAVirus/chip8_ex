defmodule TestSuites.FlagsTest do
  use ExUnit.Case

  import Chip8Ex.Chip8Helper

  alias Chip8Ex.DisplayAgent

  ## Tests

  test "run the ROM" do
    filename = Path.join(roms_path(), "4-flags.ch8")
    cpu = execute_rom(filename)
    screen = DisplayAgent.get_screen(cpu.display)

    File.write("aa.txt", screen)

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
      "  x  xx  xx  xx         x  xx  xx  xx  xx     x  xx  xx  xx  xx ",
      "xxx  x   x   x          x  x   x   x   x    xx   x   x   x   x  ",
      "                                                                ",
      "xxx                   xxx                   xxx                 ",
      "x    x x x x x x        x  x x x x x x x x  xx   x x x x x x    ",
      "xxx  xx  xx  xx         x  xx  xx  xx  xx   x    xx  xx  xx     ",
      "xxx  x   x   x          x  x   x   x   x    xxx  x   x   x      ",
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
      "xxx xxx x x xxx xx    xxx xxx                         x x   xxx ",
      "x x  x  xxx xx  x x   x   xx   x x x x            x x xxx   x x ",
      "x x  x  x x x   xx    xx  x    xx  xx             x x   x   x x ",
      "xxx  x  x x xxx x x   x   xxx  x   x               x    x x xxx ",
      "                                                                "
    ]
    |> Enum.join("\n")
  end
end
