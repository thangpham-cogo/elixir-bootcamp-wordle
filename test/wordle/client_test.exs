defmodule Wordle.ClientTest do
  use ExUnit.Case
  alias Wordle.Client

  import ExUnit.CaptureIO

  describe "get_user_input/2" do
    test "displays the right prompt if last guess was invalid" do
      formatted = "hello"
      prompt = "That was not a valid word. Try again\n"
      expected = "#{prompt}#{formatted}"

      actual =
        capture_io([input: formatted, capture_prompt: true], fn ->
          IO.write(Client.get_user_input(false, 5))
        end)

      assert actual == expected
    end

    test "displays the right prompt if last guess was valid" do
      formatted = "hello"
      prompt = "Enter a 5 letter word. You have 5 guesses left.\n"
      expected = "#{prompt}#{formatted}"

      actual =
        capture_io([input: formatted, capture_prompt: true], fn ->
          IO.write(Client.get_user_input(true, 5))
        end)

      assert actual == expected
    end

    test "trim and downcase user input" do
      expected = "hello"

      actual =
        capture_io([input: " HeLLo ", capture_prompt: false], fn ->
          IO.write(Client.get_user_input(true, 5))
        end)

      assert actual == expected
    end
  end

  test "end_game displays the correct message" do
    message = capture_io(fn -> Client.end_game("secret") end)

    assert String.match?(message, ~r/You lose.*secret/)
  end

  test "display_success displays the correct message" do
    message = capture_io(fn -> Client.display_success("secret") end)

    assert String.match?(message, ~r/You win.*secret/)
  end
end
