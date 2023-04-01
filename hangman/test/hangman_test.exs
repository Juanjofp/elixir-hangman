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

  test "New game impl should return a letter list" do
    game = Hangman.new_game("hola")

    assert game.letters == ["h", "o", "l", "a"]
  end

  test "New game should return an struct" do
    game = Hangman.new_game("hola")

    assert is_struct(game)

    assert game == %Hangman.Impl.Game{
             letters: ["h", "o", "l", "a"],
             turns_left: 7,
             used: MapSet.new([])
           }
  end

  test "Init game should return an struct" do
    game = Hangman.init_game("hola")

    assert is_struct(game)

    assert game.turns_left == 7

    assert game.game_state == :initializing

    assert game.letters == ["h", "o", "l", "a"]

    assert game.used == MapSet.new([])
  end

  test "Init game should return adios" do
    game = Hangman.init_game("adios")

    [a, d, i | os] = game.letters

    assert a == "a"
    assert d == "d"
    assert i == "i"
    assert ["o", "s"] == os
  end

  test "State doesn't change if a game is won" do
    game = Hangman.init_game("hola")

    game = Map.put(game, :game_state, :won)

    {new_game, _tally} = Hangman.make_move(game, "h")

    assert new_game == game
  end

  test "State doesn't change if a game is lost" do
    game = Hangman.init_game("hola")

    game = Map.put(game, :game_state, :lost)

    {new_game, _tally} = Hangman.make_move(game, "h")

    assert new_game == game
  end

  test "State doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Hangman.init_game("hola")

      game = Map.put(game, :game_state, state)

      {new_game, _tally} = Hangman.make_move(game, "h")

      assert new_game == game
    end
  end

  test "A duplicated letter is reported" do
    game = Hangman.init_game("hola")

    {game, _tally} = Hangman.make_move(game, "x")

    assert game.game_state != :already_used

    {game, _tally} = Hangman.make_move(game, "y")

    assert game.game_state != :already_used

    {game, _tally} = Hangman.make_move(game, "x")

    assert game.game_state == :already_used
  end

  test "Letters was stored" do
    game = Hangman.init_game("hola")

    {game, _tally} = Hangman.make_move(game, "x")
    {game, _tally} = Hangman.make_move(game, "y")
    {game, _tally} = Hangman.make_move(game, "z")

    assert MapSet.equal?(game.used, MapSet.new(["x", "y", "z"]))
  end

  test "Recognize letter 'e' and 'o' in hello" do
    game = Hangman.new_game("hello")

    {game, tally} = Hangman.make_move(game, "e")

    assert tally.game_state == :good_guess

    assert tally.used == ["e"]

    {_game, tally} = Hangman.make_move(game, "o")

    assert tally.game_state == :good_guess

    assert tally.used == ["e", "o"]
  end

  test "Win a game" do
    game = Hangman.new_game("one")

    {game, _tally} = Hangman.make_move(game, "o")
    {game, _tally} = Hangman.make_move(game, "e")
    {_game, tally} = Hangman.make_move(game, "n")

    assert tally.game_state == :won

    assert tally.used == ["e", "n", "o"]

    assert tally.letters == ["o", "n", "e"]
  end

  test "Lost a game" do
    game = Hangman.init_game("looser")

    {game, tally} = Hangman.make_move(game, "a")

    assert tally.game_state == :bad_guess

    assert tally.turns_left == 6

    {game, _tally} = Hangman.make_move(game, "w")
    {game, _tally} = Hangman.make_move(game, "x")
    {game, _tally} = Hangman.make_move(game, "y")
    {game, _tally} = Hangman.make_move(game, "z")

    {game, tally} = Hangman.make_move(game, "b")

    assert tally.game_state == :bad_guess

    assert tally.turns_left == 1

    {game, tally} = Hangman.make_move(game, "c")

    assert tally.game_state == :lost

    assert tally.turns_left == 0
  end

  test "Simulate win a game" do
    game = Hangman.init_game("game")

    {game, tally} = Hangman.make_move(game, "a")

    assert tally.game_state == :good_guess

    assert tally.turns_left == 7

    {game, _tally} = Hangman.make_move(game, "w")
    {game, _tally} = Hangman.make_move(game, "m")
    {game, _tally} = Hangman.make_move(game, "y")
    {game, _tally} = Hangman.make_move(game, "e")

    {game, tally} = Hangman.make_move(game, "b")

    assert tally.game_state == :bad_guess

    assert tally.turns_left == 4

    {game, tally} = Hangman.make_move(game, "m")

    assert tally.game_state == :already_used

    assert tally.turns_left == 4

    {game, tally} = Hangman.make_move(game, "g")

    assert tally.game_state == :won

    assert tally.turns_left == 4

    assert tally.used == ["a", "b", "e", "g", "m", "w", "y"]
  end

  test "Simulate loose a game" do
    game = Hangman.init_game("game")

    {game, tally} = Hangman.make_move(game, "a")

    assert tally.game_state == :good_guess

    assert tally.turns_left == 7

    {game, _tally} = Hangman.make_move(game, "t")
    {game, _tally} = Hangman.make_move(game, "u")
    {game, _tally} = Hangman.make_move(game, "m")
    {game, _tally} = Hangman.make_move(game, "v")
    {game, _tally} = Hangman.make_move(game, "e")
    {game, _tally} = Hangman.make_move(game, "w")
    {game, _tally} = Hangman.make_move(game, "x")
    {game, _tally} = Hangman.make_move(game, "y")
    {game, _tally} = Hangman.make_move(game, "e")

    {game, tally} = Hangman.make_move(game, "z")

    assert tally.game_state == :lost

    assert tally.turns_left == 0

    assert tally.used == ["a", "e", "m", "t", "u", "v", "w", "x", "y", "z"]
  end
end
