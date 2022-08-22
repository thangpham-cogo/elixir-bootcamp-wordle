defmodule Wordle.ClientTest do
  use ExUnit.Case
  alias Wordle.Client

  import ExUnit.CaptureIO

  test "end_game displays the correct message" do
    message = capture_io(fn -> Client.end_game("secret") end)

    assert String.match?(message, ~r/You lose.*secret/)
  end

  test "display_success displays the correct message" do
    message = capture_io(fn -> Client.display_success("secret") end)

    assert String.match?(message, ~r/You win.*secret/)
  end
end
