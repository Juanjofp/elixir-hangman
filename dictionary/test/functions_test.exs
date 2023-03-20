defmodule FunctionTest do
  use ExUnit.Case
  doctest Dictionary

  test "Anonymous Function parameters" do
    sum = fn ({a, b}) -> a + b end

    short_sum = &(&1 + &2)

    # Anonymous functions are called with a dot

    assert sum.({1, 2}) == 3

    assert short_sum.(1, 2) == 3
  end

  test "Named functions" do
    defmodule NamedFn do

      def one_line(a, b), do: a + b

      def named_fn(a, b) do
        a + b
      end

    end

    assert NamedFn.one_line(1, 2) == 3


    assert NamedFn.named_fn(1, 2) == 3

  end

  test "Pattern matching functions" do

    # Pattern matching functions works like a switch case
    # The first function that matches the pattern is executed
    # If no function matches the pattern, an error is raised
    # The order of the functions is important
    # Matching is done from top to bottom
    # Parameters are matched from left to right
    # The first parameter is matched with the first parameter of the function
    # and so on

    defmodule Length do

      def of([]), do: 0

      def of([_ | tail]), do: 1 + of(tail)

    end

    assert Length.of([1, 2, 3]) == 3

  end

  test "Function parameters" do
    defmodule Params do

      def upla_fn(u = {a, b}) do
        {b, a, is_tuple(u)}
      end

      def happy({:ok, _}), do: true
      def happy({:error, _}), do: false

      def swap({a, b}), do: {b, a}

      def same(a, a), do: true
      def same(_, _), do: false

    end

    assert Params.upla_fn({1, 2}) == {2, 1, true}

    assert Params.happy({:ok, 1}) == true
    assert Params.happy({:error, 1}) == false

    assert Params.swap({1, 2}) == {2, 1}

    assert Params.same(1, 1) == true
    assert Params.same(1, 2) == false
  end

end
