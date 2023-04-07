defmodule BotPlayer do
  @moduledoc """
  Bot to play hangman
  """
  alias Hangman.Type

  @typep game :: Hangman.game()

  @typep tally :: Type.tally()

  ###################### Auto play a game ######################

  @spec auto_play :: :ok

  def auto_play() do
    # Start game

    game = Hangman.play_game()

    tally = Hangman.tally(game)

    # Let bot to play game

    bot_play({game, tally})
  end

  ###################### Bot play a game ######################

  @spec bot_play({game, tally}) :: :ok

  def bot_play({_game, tally = %{game_state: :won}}) do
    IO.puts("Bot guess the word: #{tally.letters |> Enum.join()}")
  end

  def bot_play({_game, tally = %{game_state: :lost}}) do
    IO.puts([
      "Bot failed!!!\n",
      "\nThe word was: #{tally.letters |> Enum.join()}",
      "\nUsed letters were: #{tally.used |> Enum.join()}"
    ])
  end

  def bot_play({game, tally}) do
    # Guess a word

    Hangman.make_move(
      game,
      bot_guess_letter(
        tally.used,
        tally.letters
        |> Enum.filter(&(&1 != "_"))
      )
    )
    |> bot_play()
  end

  ###################### Bot guess a letter ######################

  @spec bot_guess_letter(list(String.t()), list(String.t())) :: String.t()

  def bot_guess_letter(used_letters, guessed_letters) do
    # guess a letter

    IO.puts("used: #{used_letters} and guessed #{guessed_letters}")

    guess_letter()
  end

  ###################### Guess a random letter ######################

  def guess_letter() do
    "abcdefghijklmnopqrstuvwxyz" |> String.split("", trim: true) |> Enum.random()
  end
end
