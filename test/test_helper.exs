Application.put_env(:chip8_ex, :keyboard_driver, Chip8Ex.KeyboardFake)
ExUnit.start()
