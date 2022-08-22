defmodule Wordle.Client do
  @color_config %{
    correct: IO.ANSI.green_background(),
    wrong: IO.ANSI.red_background(),
    wrong_place: IO.ANSI.yellow_background()
  }

  @spec get_guess(last_guess_valid :: boolean(), num_of_guesses :: non_neg_integer()) ::
          String.t()
  def get_guess(true, num_of_guesses) do
    get_user_input("Enter a 5 letter word. You have #{num_of_guesses} guesses left.\n")
  end

  def get_guess(false, _) do
    get_user_input("That was not a valid word. Try again\n")
  end

  def ask_user_to_restart() do
    get_user_input(~s|Enter "yes" to play again, anything else to exit\n|)
  end

  def display_success(secret) do
    IO.puts(~s|You win. The secret word is #{green_bg(secret)}|)
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

  def display_failure(secret) do
    IO.puts(~s|You lose. The secret is #{green_bg(secret)}|)
  end

  defp get_user_input(prompt) do
    prompt
    |> IO.gets()
    |> format_input()
  end

  defp format_input(input) do
    input
    |> String.trim()
    |> String.downcase()
  end

  @spec color(Wordle.attempt()) :: list(String.t())
  defp color({char, result}), do: [@color_config[result], char, IO.ANSI.reset()]

  defp green_bg(str) do
    "#{IO.ANSI.green_background()}#{str}#{IO.ANSI.reset()}"
  end
end
