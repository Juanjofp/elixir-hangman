defmodule Hangman do

  # alias Hangman.Impl.Game, as: Game
  alias Hangman.Impl.Game

  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @opaque game :: Game.t

  @type tally :: %{
    turns_left: integer,
    game_state: state,
    letters: list(String.t),
    used: list(String.t),
  }

  # Ejemplo de delegación, es como si estuviera definiendo la función
  # new_game/0 en este módulo, pero en realidad está delegando la
  # implementación a Hangman.Impl.Game.new_game/0

  # Es equivalente a:
  # def new_game do
  #   # Hangman.Impl.Game.new_game()
  #   Game.new_game()
  # end

  @spec new_game(String.t) :: game
  defdelegate new_game(word), to: Game

  # Ejemplo de delegación con alias
  # Es como si estuviera definiendo la función init_game/1 en este módulo,
  # pero en realidad está delegando la implementación a Hangman.Impl.Game.new_game/1

  @spec init_game(String.t) :: game
  defdelegate init_game(word), to: Game, as: :new_game

  @spec make_move(game, String.t) :: {game, tally}
  def make_move(game, _guess) do
    game
  end
end
