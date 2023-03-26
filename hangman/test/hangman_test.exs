defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "New game should has 7 turns" do
    game = Hangman.init_game("aword")

    assert game.turns_left == 7
  end

  test "New game word shoul start with a lower case letter" do
    game = Hangman.init_game("aword")

    [first_letter | _] = game.letters

    assert first_letter =~ ~r/^[a-z]/
  end

  test "New game word should have more than 3 letters" do
    game = Hangman.init_game("aword")

    assert length(game.letters) > 3
  end

  test "New game impl should return a game struct" do
    game = Hangman.new_game("hola")

    assert game.letters == ["h", "o", "l", "a"]
  end

end
