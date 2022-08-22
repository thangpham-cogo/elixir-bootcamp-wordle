defmodule Wordle.Game do
  def check_guess(_guess) do
    {:ok}
  end

  @spec validate_word(String.t(), list(String.t())) :: {:ok, String.t()} | :error
  def validate_word(word, all_words) do
    case word in all_words do
      true -> {:ok, word}
      _ -> :error
    end
  end

  def process_guess(guess, secret)
  def process_guess(guess, guess), do: :ok

  def process_guess(guess, target) do
    target_list = String.graphemes(target)
    guess_list = String.graphemes(guess)

    not_found = target_list -- guess_list
    found_list = target_list -- not_found

    %{result: result} =
      Enum.zip(guess_list, target_list)
      |> Enum.reduce(
        %{found: found_list, result: []},
        fn {guess, target}, %{found: found, result: result} ->
          cond do
            guess == target ->
              %{found: List.delete(found, target), result: [:correct | result]}

            guess in found ->
              %{found: List.delete(found, target), result: [:wrong_place | result]}

            true ->
              %{found: found, result: [:wrong | result]}
          end
        end
      )

    {:error, Enum.reverse(result)}
  end
end
