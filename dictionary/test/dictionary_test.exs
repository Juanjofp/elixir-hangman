defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "fib(5) is 5" do
    assert Dictionary.fib(5) == 5
  end

  test "Anagram of juanjo is jaunjo" do
    assert "juanjo"
           |> String.split("")
           |> Enum.sort()
           |> Enum.join() == "ajjnou"
  end

  test "Length of word is 3" do
    assert "word"
           |> String.split("", trim: true)
           |> length() == 4
  end

  test "Dictionary.random_word() is a string" do
    assert is_binary(Dictionary.random_word())
  end

  test "Dictionary.random_word() is not empty" do
    assert Dictionary.random_word() != ""
  end

  test "Dictionary.random_word() is not nil" do
    assert Dictionary.random_word() != nil
  end

  test "Dictionary.random_word() return two different words" do
    assert Dictionary.random_word() != Dictionary.random_word()
  end
end
