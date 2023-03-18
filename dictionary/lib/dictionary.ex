defmodule Dictionary do

  @word_list "assets/words.txt"
  |> File.read!()
  |> String.split(~r/\n/, trim: true)

  def random_word() do
    @word_list
    |> Enum.random()
  end

  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end

end
