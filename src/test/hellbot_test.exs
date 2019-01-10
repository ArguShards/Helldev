defmodule HellbotTest do
  use ExUnit.Case
  doctest Hellbot

  test "greets the world" do
    assert Hellbot.hello() == :world
  end
end
