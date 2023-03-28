defmodule Hangman.Impl.Game do

  alias Hangman.Type

  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Type.state,
    letters: list(String.t),
    used: list(String.t)
  }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: []
  )

  # @spec new_game :: t()
  # def new_game do
  #   # %Hangman.Impl.Game{
  #   #   letters: Dictionary.random_word() |> String.codepoints()
  #   # }
  #   %__MODULE__{
  #     letters: Dictionary.random_word() |> String.codepoints()
  #   }
  # end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  ########################################

  @spec make_move(t, String.t) :: {t, Type.tally}
  def make_move(game = %{game_state: state}, _guess)
  when state in [:won, :lost] do

    game |> return_with_tally()

  end

  def make_move(game, guess) do

    duplicated = Enum.find_value(game.used, nil, &(&1 == guess)) != nil

    accept_guess(game, guess, duplicated)
    |> return_with_tally()
  end

  ########################################

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _already_used) do
    %{game | used: [guess | game.used] |> Enum.sort()}
  end

  ########################################

defp return_with_tally(game) do
    {game, tally(game)}
end

  ########################################

  defp tally(game) do

    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: [],
      used: game.used
    }

  end
end
