defmodule Wordle.Game do
  @type result_type() :: :correct | :wrong_place | :wrong

  @spec validate_word(String.t(), list(String.t())) :: :ok | :error
  def validate_word(word, all_words) do
    case word in all_words do
      true -> :ok
      _ -> :error
    end
  end

  @spec process_guess(guess :: String.t(), secret :: String.t()) ::
          :win | {:ok, list(result_type())}
  def process_guess(guess, secret)
  def process_guess(guess, guess), do: :win

  def process_guess(guess, target) do
    {pairs, initial_state} = prepare(guess, target)

    # reduce becomes complicated the momment the acc is not just a list
    {_, result} = Enum.reduce(pairs, initial_state, &compare/2)

    # hmm we can easily miss this, also reversing is an implementation details
    {:ok, Enum.reverse(result)}
  end

  defp prepare(guess, target) do
    target_list = String.graphemes(target)
    guess_list = String.graphemes(guess)

    not_found = target_list -- guess_list
    found_list = target_list -- not_found

    pairs = Enum.zip(guess_list, target_list)
    {pairs, {found_list, []}}
  end

  defp compare({guess, target}, {found, result}) do
    cond do
      guess == target ->
        {List.delete(found, guess), [:correct | result]}

      guess in found ->
        {List.delete(found, guess), [:wrong_place | result]}

      true ->
        {found, [:wrong | result]}
    end
  end
end
