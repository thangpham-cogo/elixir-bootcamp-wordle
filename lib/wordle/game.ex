defmodule Wordle.Game do
  @type result_type() :: :correct | :wrong_place | :wrong

  def check_guess(_guess) do
    {:ok}
  end

  @spec validate_word(String.t(), list(String.t())) :: :ok | :error
  def validate_word(word, all_words) do
    case word in all_words do
      true -> :ok
      _ -> :error
    end
  end

  def process_guess(guess, secret)
  def process_guess(guess, guess), do: :ok

  def process_guess(guess, target) do
    %{pairs: pairs, initial_state: initial_state} = prepare(guess, target)

    %{result: result} = Enum.reduce(pairs, initial_state, &compare/2)

    {:ok, Enum.reverse(result)}
  end

  defp prepare(guess, target) do
    target_list = String.graphemes(target)
    guess_list = String.graphemes(guess)

    not_found = target_list -- guess_list
    found_list = target_list -- not_found

    pairs = Enum.zip(guess_list, target_list)
    %{pairs: pairs, initial_state: %{found: found_list, result: []}}
  end

  defp compare({guess, target}, %{found: found, result: result}) do
    cond do
      guess == target ->
        %{found: List.delete(found, guess), result: [:correct | result]}

      guess in found ->
        %{found: List.delete(found, guess), result: [:wrong_place | result]}

      true ->
        %{found: found, result: [:wrong | result]}
    end
  end
end
