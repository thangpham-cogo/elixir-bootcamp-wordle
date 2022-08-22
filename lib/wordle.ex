defmodule Wordle do
  @moduledoc """
  Documentation for `Wordle`.
  """

  @all_words_file_path "#{File.cwd!()}/priv/all_words.txt"
  @all_secrets_file_path "#{File.cwd!()}/priv/words.txt"
  @num_of_guesses 2

  alias Wordle.{Game}

  def start() do
    all_words = load_word_list(@all_words_file_path)
    secret = pick_secret_word(@all_secrets_file_path)
    IO.puts("Secret is #{secret}")
    loop(secret, all_words, @num_of_guesses)
  end

  defp loop(secret, _, 0), do: end_game(secret)

  defp loop(secret, all_words, num_of_guesses) do
    guess =
      get_user_input(
        "Enter a 5 leter word. You have #{num_of_guesses} guesses left.\n",
        all_words
      )

    case Game.process_guess(guess, secret) do
      :ok ->
        display_success(secret)

      {:error, reasons} ->
        display_reasons(reasons, guess)
        loop(secret, all_words, num_of_guesses - 1)
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

  defp display_reasons(reasons, guess) do
    IO.puts("Guess again \n")
    IO.inspect(Enum.zip(String.graphemes(guess), reasons))
  end

  defp end_game(secret) do
    IO.puts(~s|You lose. The secret is "#{secret}"|)
  end
end
