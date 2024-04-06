defmodule TestSuites.IBMLogoTest do
  use Chip8Ex.Case

  ## Tests

  test "run the ROM", %{vm: vm} do
    filename = Path.join(roms_path(), "2-ibm-logo.ch8")
    vm = execute_rom(vm, filename, 20)
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
      "                                                       x        ",
      "            xxxxxxxx xxxxxxxxxxx xxxxx   xxx   xxxxx  xx        ",
      "                                                       x        ",
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
