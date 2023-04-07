defmodule BotPlayerTest do
  use ExUnit.Case
  doctest BotPlayer

  test "greets the world" do
    assert BotPlayer.hello() == :world
  end
end
