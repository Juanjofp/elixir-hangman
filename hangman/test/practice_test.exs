defmodule HangmanPracticeTest do
  use ExUnit.Case
  doctest Hangman

  test "Pattern matching should work" do

    assert {:ok, 1} = {:ok, 1}
  end

  test "Patern matching should fail" do
    assert_raise(
      MatchError,

      fn -> {:ok, 1} = {:ok, 2} end
    )
  end

  test "Refute an assertion" do
    refute(1 == 2)
  end
end
