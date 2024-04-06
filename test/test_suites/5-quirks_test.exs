defmodule TestSuites.QuirksTest do
  use ExUnit.Case

  import Chip8Ex.Chip8Helper

  ## Tests

  test "run the ROM" do
    filename = Path.join(roms_path(), "5-quirks.ch8")
    vm = execute_rom(filename)
    screen = get_vm_display(vm)

    File.write("aa.txt", screen)

    assert screen == expected_screen()
  end

  defp expected_screen() do
    []
    |> Enum.join()
  end
end
