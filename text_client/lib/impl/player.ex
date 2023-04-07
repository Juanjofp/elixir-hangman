defmodule TextClient.Impl.Player do
  ###################### Types ######################

  @typep game :: Hangman.game()

  @typep tally :: Hangman.Type.tally()

  @typep state :: {game, tally}

  ###################### Start game ######################

  @spec start() :: :ok
  def start() do
    game = Hangman.play_game()

    tally = Hangman.tally(game)

    interact({game, tally})
  end

  ###################### Game loop ######################

  @spec interact(state) :: :ok

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congratulations, you won!!!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost... the word was #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    # feedback

    IO.puts(feedback_for(tally))

    # show current word

    IO.puts(current_word(tally))

    Hangman.make_move(game, guess_letter())
    |> interact()
  end

  ###################### Feedback for player ######################

  defp feedback_for(tally = %{game_state: :initializing}),
    do: "I'm thinking a word of #{length(tally.letters)} letters"

  defp feedback_for(%{game_state: :good_guess}),
    do: "Good guess!"

  defp feedback_for(%{game_state: :bad_guess}),
    do: "Bad guess!"

  defp feedback_for(%{game_state: :already_used}),
    do: "Already used!"

  ###################### Current word info ######################

  def current_word(tally) do
    [
      "\n",
      "Word: #{tally.letters |> Enum.join(" ")}",
      "\nTurns: #{tally.turns_left}",
      "\nUsed: #{tally.used}",
      "\n",
      "\n-----------------------------\n"
    ]
  end

  ###################### Guess a letter ######################

  def guess_letter() do
    IO.gets("Type a letter: ") |> String.trim() |> String.downcase()
  end
end
