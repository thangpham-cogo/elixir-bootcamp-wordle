defmodule Wordle do
  @moduledoc """
  Documentation for `Wordle`.
  """

  @all_words_file_path "#{File.cwd!()}/priv/all_words.txt"
  @all_secrets_file_path "#{File.cwd!()}/priv/words.txt"
  @num_of_guesses 4

  alias Wordle.{Game}

  def start() do
    all_words = load_word_list(@all_words_file_path)
    secret = pick_secret_word(@all_secrets_file_path)
    IO.puts("Secret is #{secret}")
    loop(secret, all_words)
  end

  defp loop(secret, all_words, num_of_guesses \\ @num_of_guesses, attempts \\ [])
  defp loop(secret, _, 0, _), do: end_game(secret)

  defp loop(secret, all_words, num_of_guesses, attempts) do
    guess =
      get_user_input(
        "Enter a 5 leter word. You have #{num_of_guesses} guesses left.\n",
        all_words
      )

    case Game.process_guess(guess, secret) do
      :ok ->
        display_success(secret)

      {:ok, reasons} ->
        attempts = attempts ++ [{guess, reasons}]
        display_reasons(attempts)
        loop(secret, all_words, num_of_guesses - 1, attempts)
    end
  end

  defp get_user_input(prompt, all_words) do
    IO.gets(prompt)
    |> String.trim()
    |> Game.validate_word(all_words)
    |> case do
      {:ok, word} -> word
      :error -> get_user_input("That was not a valid word. Try again\n", all_words)
    end
  end

  defp display_success(word) do
    IO.puts("You win. The secret word is #{word}")
  end

  defp load_word_list(path) do
    path
    |> File.read!()
    |> String.split()
  end

  defp pick_secret_word(path) do
    path
    |> load_word_list()
    |> Enum.random()
  end

  defp display_reasons(attempts) do
    IO.puts("Guess again \n")

    Enum.each(attempts, fn {guess, result} ->
      IO.inspect(Enum.zip(String.graphemes(guess), result))
    end)
  end

  defp end_game(secret) do
    IO.puts(~s|You lose. The secret is "#{secret}"|)
  end
end
