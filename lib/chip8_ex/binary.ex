defmodule Chip8Ex.Binary do
  @moduledoc """
  TODO: Documentation
  """

  ## Public API

  def read(bin, start, n) do
    <<_::binary-size(start), data::binary-size(n), _::binary>> = bin
    data
  end

  def read_byte(bin, start) do
    <<_::binary-size(start), data::8, _::binary>> = bin
    data
  end

  def write(bin, start, bytes) do
    bytes_size = byte_size(bytes)
    <<prefix::binary-size(start), _::binary-size(bytes_size), suffix::binary>> = bin
    <<prefix::binary-size(start), bytes::binary, suffix::binary>>
  end

  def write_byte(bin, start, b) do
    <<prefix::binary-size(start), _::8, suffix::binary>> = bin
    <<prefix::binary-size(start), b::8, suffix::binary>>
  end
end
