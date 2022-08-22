defmodule Wordle.GameTest do
  use ExUnit.Case
  alias Wordle.Game

  describe "validate_word/2" do
    test "returns :ok if word is valid" do
      assert Game.validate_word("hello", ["hello"]) == :ok
    end

    test "returns :error if word is valid" do
      assert Game.validate_word("ola", ["hello"]) == :error
    end
  end

  describe "process_guess/2" do
    test "returns :win if guess matches target" do
      assert Game.process_guess("hello", "hello") == :win
    end

    test "returns :wrong for all letters in guess if none matches" do
      expected = {:ok, List.duplicate(:wrong, 5)}

      assert Game.process_guess("hello", "spank") == expected
    end

    test "returns :wrong for 2nd occurence of a letter in guess if the first occurence already matches" do
      assert {:ok, [:correct, :wrong, :wrong_place, :wrong, _]} =
               Game.process_guess("ssllf", "slide")
    end

    test "returns :correct for any letter that matches" do
      assert {:ok, [_, :correct, :correct, :correct, :correct]} =
               Game.process_guess("hello", "jello")
    end
  end
end
