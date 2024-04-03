defmodule TestSuites.Chip8LogoTest do
  use ExUnit.Case

  import Chip8Ex.Chip8Helper

  alias Chip8Ex.DisplayAgent

  ## Tests

  test "run the ROM" do
    filename = Path.join(roms_path(), "1-chip8-logo.ch8")
    cpu = execute_rom(filename, 39)
    screen = DisplayAgent.get_screen(cpu.display)

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
      "        xxx       xxx   xx xxx xxx x x   xxx xxx      xx        ",
      "         xxx   xx xxx   xx xxx xxx xxx   x x xxxx    xxx        ",
      "          xxxxxxx xxx   xx xxx xxx   x   x x  xxxxxxxxx         ",
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
    |> Enum.join("\n")
  end
end