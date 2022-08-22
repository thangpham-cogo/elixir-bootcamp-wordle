defmodule Wordle.Client do
  def get_user_input(prompt) do
    IO.gets(prompt)
    |> String.trim()
  end

  def display_success(secret) do
    IO.puts(~s|You win. The secret word is "#{secret}"|)
  end

  def display_attempts(attempts) do
    IO.puts("Guess again \n")

    Enum.each(attempts, fn {guess, result} ->
      guess
      |> String.graphemes()
      |> Enum.zip(result)
      |> Enum.map(&color/1)
      |> Enum.map(&Enum.concat(&1, [IO.ANSI.reset()]))
      |> IO.puts()
    end)
  end

  def end_game(secret) do
    IO.puts(~s|You lose. The secret is #{IO.ANSI.green_background()}#{secret}|)
  end

  defp color({char, :wrong}), do: [IO.ANSI.red_background(), char]
  defp color({char, :correct}), do: [IO.ANSI.green_background(), char]
  defp color({char, :wrong_place}), do: [IO.ANSI.yellow_background(), char]
end
