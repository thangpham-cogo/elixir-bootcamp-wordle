defmodule Wordle.Client do
  @color_config %{
    correct: IO.ANSI.green_background(),
    wrong: IO.ANSI.red_background(),
    wrong_place: IO.ANSI.yellow_background()
  }

  @spec get_user_input(String.t()) :: String.t()
  def get_user_input(prompt) do
    IO.gets(prompt)
    |> String.trim()
    |> String.downcase()
  end

  def display_success(secret) do
    IO.puts(~s|You win. The secret word is #{IO.ANSI.green_background()}#{secret}|)
  end

  @spec display_attempts(list(Wordle.attempt())) :: :ok
  def display_attempts(attempts) do
    IO.puts("Guess again \n")

    Enum.each(attempts, fn {guess, result} ->
      guess
      |> String.graphemes()
      |> Enum.zip(result)
      |> Enum.map(&color/1)
      |> IO.puts()
    end)
  end

  def end_game(secret) do
    IO.puts(~s|You lose. The secret is #{IO.ANSI.green_background()}#{secret}|)
  end

  @spec color(Wordle.attempt()) :: list(String.t())
  defp color({char, result}), do: [@color_config[result], char, IO.ANSI.reset()]
end
