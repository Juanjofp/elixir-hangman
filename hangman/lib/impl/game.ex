defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer,
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  ###################### New game ######################

  # @spec new_game :: t()
  # def new_game do
  #   # %Hangman.Impl.Game{
  #   #   letters: Dictionary.random_word() |> String.codepoints()
  #   # }
  #   %__MODULE__{
  #     letters: Dictionary.random_word() |> String.codepoints()
  #   }
  # end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  ################### make a move #####################

  @spec make_move(t, String.t()) :: {t, Type.tally()}
  def make_move(game = %{game_state: state}, _guess)
      when state in [:won, :lost] do
    game |> return_with_tally()
  end

  def make_move(game, guess) do
    valid_guess(game, guess, valid_guess?(guess))
    |> return_with_tally()
  end

  ################## Valid guesst ######################

  defp valid_guess?(guess) do
    String.valid?(guess) and Regex.match?(~r/^[a-z]+$/, guess)
  end

  defp valid_guess(game, guess, _valid_guess = true) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
  end

  defp valid_guess(game, _guess, _valid_guess) do
    %{game | game_state: :invalid_guess}
  end

  ################## Accept a guesst ######################

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _already_used) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  ################### Score a guesst #####################

  @spec score_guess(t, boolean) :: t
  defp score_guess(game, _good_guess = true) do
    # guessed all letters -> :won | :good_guess

    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))

    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _bas_guess) do
    # turns_left == 1 -> :lost

    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(game = %{turns_left: turns_left}, _bas_guess) do
    # decrement turns_left, :bad_guess

    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  ###################### maybe_one ######################

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  ###################### tally(game) ######################

  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  ################### Return game and tally #####################

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  ###################### reveal guessed letters ######################

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  ###################### Maybe reveal letter or underscore ######################

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _), do: "_"
end
