defmodule HangmanSimultateTest do
  use ExUnit.Case
  doctest Hangman

  test "Simulate some moves" do
    # Game flow

    [
      # guess | state | turns |    letters         | used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]]
    ]
    |> test_sequence_of_moves("hello")
  end

  test "Simulate win game" do
    # Game flow

    [
      # guess | state | turns |    letters         | used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "x"]],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x"]],
      ["y", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "x", "y"]],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "e", "h", "l", "o", "x", "y"]]
    ]
    |> test_sequence_of_moves("hello")
  end

  test "Simulate loose game" do
    # Game flow

    [
      # guess | state | turns |    letters         | used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["b", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "b"]],
      ["c", :bad_guess, 4, ["_", "_", "_", "_", "_"], ["a", "b", "c"]],
      ["d", :bad_guess, 3, ["_", "_", "_", "_", "_"], ["a", "b", "c", "d"]],
      ["e", :good_guess, 3, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e"]],
      ["f", :bad_guess, 2, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f"]],
      ["g", :bad_guess, 1, ["_", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g"]],
      ["h", :good_guess, 1, ["h", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g", "h"]],
      ["i", :lost, 0, ["h", "e", "_", "_", "_"], ["a", "b", "c", "d", "e", "f", "g", "h", "i"]]
    ]
    |> test_sequence_of_moves("hello")
  end

  ###################### Tests helpers ######################

  ###################### Test sequence of moves ######################

  def test_sequence_of_moves(script, word) do
    game = Hangman.new_game(word)

    Enum.reduce(script, game, &check_one_move/2)
  end

  ###################### Simulate moves ######################

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Hangman.make_move(game, guess)

    assert tally.game_state == state

    assert tally.turns_left == turns

    assert tally.letters == letters

    assert tally.used == used

    game
  end
end
