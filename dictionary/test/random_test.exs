defmodule RandomTest do
  use ExUnit.Case
  doctest Dictionary

  test "Random test sample" do
    assert 5 == 5
  end

  test "Integers and floats" do
    assert 1 == 1.0

    assert 1_000_000 == 1_000_000

    assert 0x1F == 31

    assert 0b1010 == 10

    assert 1.0e-10 == 0.0000000001

    assert 0o17 == 15

    assert ?A == 65

    assert ?\s == 32
  end

  test "Functions for number" do
    assert div(10, 3) == 3

    assert 5 / 2 == 2.5

    assert trunc(2.5) == 2

    assert round(2.5) == 3

    assert rem(10, 3) == 1

    assert 2.0e4 == 20_000

    assert Integer.pow(2, 4) == 16
  end

  test "Strings" do
    assert String.to_integer("1") == 1

    assert String.to_integer("100", 2) == 4

    assert String.to_integer("100", 8) == 64

    assert String.to_integer("100", 16) == 256

    assert String.to_float("1.0") == 1.0

    assert String.length("Hello") == 5
  end

  test "Atoms" do
    :atom
    :atom!
    :atom?
    :>=
    :"!@$%^&UIO"
    :"atom with spaces"
    :"atom with #{1 + 1} interpolation"

    assert is_atom(:atom)
    assert is_atom(:atom!)
    assert is_atom(:atom?)
    assert is_atom(:>=)
    assert is_atom(:"!@$%^&UIO")
    assert is_atom(:"atom with spaces")
    assert is_atom(:"atom with 2 interpolation")

    assert :atom == :atom
    assert :atom != :atom!
    assert :atom != :atom?
    assert :atom != :>=
    assert :atom != :"!@$%^&UIO"
    assert :atom != :"atom with spaces"
    assert :"atom with #{1 + 1} interpolation" == :"atom with 2 interpolation"
  end

  test "Booleans and bits operators" do
    import Bitwise

    assert true and true == true

    assert true and false == false

    assert true or false == true

    assert File.exists?("test/random_test.exs") or File.exists?("test/random_test.exs") == true

    assert File.exists?("test/random_test.exs") and File.exists?("test/random_test.exs") == true

    assert File.exists?("test/random_test.exs") && File.exists?("test/random_test.exs") == true

    assert File.exists?("test/random_test.exs") || File.exists?("test/random_test.exs") == true

    assert 1 <<< 2 == 4

    assert 4 >>> 2 == 1

    assert (0b1010 &&& 0b1100) == 0b1000

    assert (0b1010 ||| 0b1100) == 0b1110

    # assert (0b1010 ^^^ 0b1100) == 0b0110

    # assert (0b1010 ~~~ 0b1100) == 0b0101

    assert Bitwise.bxor(0b1010, 0b1100) == 0b0110

    assert Bitwise.bnot(0b1010) == -11

    assert Bitwise.band(0b1010, 0b1100) == 0b1000

    assert Bitwise.bor(0b1010, 0b1100) == 0b1110
  end

  test "Range of integers" do
    r1 = 1..10

    r2 = 11..20

    assert 5 in r1 == true

    assert 5 in r2 == false

    assert for i <- r1, do: i * 2 == [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
  end

  test "Regular expression" do
    assert "casa" =~ ~r/cas/ == true

    assert "abc" =~ ~r/a.c/ == true

    assert "arc" =~ ~r/a.c/ == true

    assert "ace" =~ ~r/a.c/ == false

    res = "cats like catnip" |> String.replace(~r/cat/, "dog")

    assert res == "dogs like dognip" == true

    res = "cats like catnip" |> String.replace(~r/cat/, "dog", global: false)

    assert res == "dogs like catnip" == true
  end

  test "Maps" do
    m = %{name: "John", age: 27}

    assert m[:name] == "John"

    assert m[:age] == 27

    assert m.name == "John"

    assert m.age == 27

    assert Map.get(m, :name) == "John"

    assert Map.get(m, :age) == 27

    assert Map.get(m, :city, "NY") == "NY"

    assert Map.get(m, :city) == nil

    assert Map.keys(m) == [:age, :name]

    assert Map.values(m) == [27, "John"]

    assert Map.has_key?(m, :name) == true

    assert Map.has_key?(m, :city) == false

    assert Map.has_key?(m, :age) == true
  end
end
