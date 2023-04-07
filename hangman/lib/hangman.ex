defmodule Hangman do
  # alias Hangman.Impl.Game, as: Game
  alias Hangman.Impl.Game

  alias Hangman.Type

  @opaque game :: Game.t()

  # Ejemplo de delegación, es como si estuviera definiendo la función
  # new_game/0 en este módulo, pero en realidad está delegando la
  # implementación a Hangman.Impl.Game.new_game/0

  # Es equivalente a:
  # def new_game do
  #   # Hangman.Impl.Game.new_game()
  #   Game.new_game()
  # end

  @spec new_game(String.t()) :: game
  defdelegate new_game(word), to: Game

  # Ejemplo de delegación con alias
  # Es como si estuviera definiendo la función init_game/1 en este módulo,
  # pero en realidad está delegando la implementación a Hangman.Impl.Game.new_game/1

  @spec init_game(String.t()) :: game
  defdelegate init_game(word), to: Game, as: :new_game

  @spec make_move(game, String.t()) :: {game, Type.tally()}
  defdelegate make_move(game, guess), to: Game

  ###### API ######

  # Play a new game

  @spec play_game() :: game
  def play_game() do
    Dictionary.random_word() |> init_game()
  end

  @spec tally(game) :: Type.tally()
  defdelegate tally(game), to: Game
end
