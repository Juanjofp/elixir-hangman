defmodule ListsTest do
  use ExUnit.Case
  doctest Dictionary

  test "List concatenation" do
    assert [1, 2] ++ [3, 4] == [1, 2, 3, 4]
  end

  test "List subtraction" do
    assert [1, 2, 3, 4] -- [2, 4] == [1, 3]
  end

  test "List subtraction with duplicates" do
    assert [1, 2, 2, 3, 4] -- [2, 4] == [1, 2, 3]
  end

  test "List subtraction with non-existent elements" do
    assert [1, 2, 3, 4] -- [5, 6] == [1, 2, 3, 4]
  end

  test "List head and tail" do

    [head, next_head | tail] = [1, 2, 3, 4]

    assert head == 1
    assert next_head == 2
    assert tail == [3, 4]

  end

  test "List head and tail with a single element" do

    [head | tail] = [1]

    assert head == 1
    assert tail == []

  end

  test "List head and tail with an empty list" do

    assert_raise MatchError, "no match of right hand side value: []", fn ->

      [_head | _tail] = []

    end

  end


  test "Pattern matching with lists" do
    defmodule LengthTest do

      def len([]), do: 0
      def len([_head | tail]), do: 1 + len(tail)


    end

    assert LengthTest.len([1, 2, 3]) == 3
  end

  test "Sum of a lists" do
    defmodule SumTest do

      def sum([]), do: 0
      def sum([head | tail]), do: head + sum(tail)
    end

    assert SumTest.sum([1, 2, 3]) == 6
  end

  test "List is even or odd" do
    defmodule EvenOddTest do

      def even?([]), do: true
      def even?([_head | []]), do: false
      def even?([_, _ | tail]), do: even?(tail)

      def even2?([]), do: true
      def even2?([_head | tail]), do: !even2?(tail)
    end

    even_list = [1, 2, 3, 4]
    odd_list = [1, 2, 3, 4, 5]

    assert EvenOddTest.even?(even_list) == true
    assert EvenOddTest.even?(odd_list) == false

    assert EvenOddTest.even2?(even_list) == true
    assert EvenOddTest.even2?(odd_list) == false

  end

  test "Square list" do
    defmodule SquareTest do

      def square([]), do: []
      def square([head | tail]), do: [head * head | square(tail)]

    end

    assert SquareTest.square([1, 2, 3]) == [1, 4, 9]
  end

  test "Double list" do
    defmodule DoubleTest do

      def double([]), do: []
      def double([head | tail]), do: [head * 2 | double(tail)]

    end

    assert DoubleTest.double([1, 2, 3]) == [2, 4, 6]
  end

  test "Map a list from scratch" do
    defmodule MapTest do

      def map([], _func), do: []
      def map([head | tail], predicate), do: [predicate.(head) | map(tail, predicate)]

      end

      assert MapTest.map([1, 2, 3], &(&1 * 2)) == [2, 4, 6]

      map_fn = fn (value) -> value * 2 end
      assert MapTest.map([1, 2, 3], map_fn) == [2, 4, 6]

      assert MapTest.map([1, 2, 3], fn (value) -> value * 2 end) == [2, 4, 6]

  end

  test "Map a list with Enum.map" do
    assert Enum.map([1, 2, 3], &(&1 * 2)) == [2, 4, 6]

    map_fn = fn (value) -> value * 2 end
    assert Enum.map([1, 2, 3], map_fn) == [2, 4, 6]

    assert Enum.map([1, 2, 3], fn (value) -> value * 2 end) == [2, 4, 6]
  end

  test "Filter a list from scratch" do
    defmodule FilterTest do

      def filter([], _func), do: []
      def filter([head | tail], predicate) do
        if predicate.(head) do
          [head | filter(tail, predicate)]
        else
          filter(tail, predicate)
        end
      end

    end

    assert FilterTest.filter([1, 2, 3], &(&1 > 2)) == [3]

    filter_fn = fn (value) -> value > 2 end
    assert FilterTest.filter([1, 2, 3], filter_fn) == [3]

    assert FilterTest.filter([1, 2, 3], fn (value) -> value > 2 end) == [3]
  end

  test "Filter a list with Enum.filter" do
    assert Enum.filter([1, 2, 3], &(&1 > 2)) == [3]

    filter_fn = fn (value) -> value > 2 end
    assert Enum.filter([1, 2, 3], filter_fn) == [3]

    assert Enum.filter([1, 2, 3], fn (value) -> value > 2 end) == [3]
  end

  test "Reduce a list from scratch" do
    defmodule ReduceTest do

      def reduce([], _func, acc), do: acc
      def reduce([head | tail], predicate, acc), do: reduce(tail, predicate, predicate.(head, acc))

    end

    assert ReduceTest.reduce([1, 2, 3], fn (value, acc) -> value + acc end, 0) == 6

    reduce_fn = fn (value, acc) -> value + acc end
    assert ReduceTest.reduce([1, 2, 3], reduce_fn, 0) == 6

    assert ReduceTest.reduce([1, 2, 3], fn (value, acc) -> value + acc end, 0) == 6
  end

  test "Reduce a list with Enum.reduce" do
    assert Enum.reduce([1, 2, 3], 0, fn (value, acc) -> value + acc end) == 6

    reduce_fn = fn (value, acc) -> value + acc end
    assert Enum.reduce([1, 2, 3], 0, reduce_fn) == 6

    assert Enum.reduce([1, 2, 3], 0, fn (value, acc) -> value + acc end) == 6
  end

  test "Combine Enums functions" do

    assert [1, 2, 3, 4, 5]
      |> Enum.map(&(&1 * 3))
      |> Enum.filter(&(&1 > 6))
      |> Enum.product() == 1620

  end

  test "Reduce list to a list with each element is the element plus next element" do
    defmodule ReduceListTest do
      def reduce_list([]), do: []
      def reduce_list([head | []]), do: [head]
      def reduce_list([head | tail]), do: [head + List.first(tail) | reduce_list(tail)]
      # def reduce_list([head, next | tail]), do: [head + next | reduce_list([next | tail])]
    end

    assert ReduceListTest.reduce_list([1, 2, 3, 4, 5, 6]) == [3, 5, 7, 9, 11, 6]

  end

end
