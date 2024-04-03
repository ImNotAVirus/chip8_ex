defmodule TestSuites.QuirksTest do
  use ExUnit.Case

  import Chip8Ex.Chip8Helper

  alias Chip8Ex.DisplayAgent

  ## Tests

  test "run the ROM" do
    filename = Path.join(roms_path(), "5-quirks.ch8")
    cpu = execute_rom(filename)
    screen = DisplayAgent.get_screen(cpu.display)

    File.write("aa.txt", screen)

    assert screen == expected_screen()
  end

  defp expected_screen() do
    [
    ]
    |> Enum.join("\n")
  end
end
