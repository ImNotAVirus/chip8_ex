defmodule TestSuites.IBMLogoTest do
  use ExUnit.Case

  import Chip8Ex.Chip8Helper

  ## Tests

  test "run the ROM" do
    filename = Path.join(roms_path(), "2-ibm-logo.ch8")
    vm = execute_rom(filename, 20)
    screen = get_vm_display(vm)

    assert screen == expected_screen()
  end

  defp expected_screen() do
    [
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "            xxxxxxxx xxxxxxxxx   xxxxx         xxxxx  x x       ",
      "                                                      x x       ",
      "            xxxxxxxx xxxxxxxxxxx xxxxxx       xxxxxx   x        ",
      "                                                                ",
      "              xxxx     xxx   xxx   xxxxx     xxxxx    x x       ",
      "                                                      xxx       ",
      "              xxxx     xxxxxxx     xxxxxxx xxxxxxx      x       ",
      "                                                        x       ",
      "              xxxx     xxxxxxx     xxx xxxxxxx xxx              ",
      "                                                       x        ",
      "              xxxx     xxx   xxx   xxx  xxxxx  xxx              ",
      "                                                      xxx       ",
      "            xxxxxxxx xxxxxxxxxxx xxxxx   xxx   xxxxx  x x       ",
      "                                                      x x       ",
      "            xxxxxxxx xxxxxxxxx   xxxxx    x    xxxxx  xxx       ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                ",
      "                                                                "
    ]
    |> Enum.join()
  end
end
