defmodule Wordle.Dictionary do
  def load_word_list(path) do
    path
    |> File.read!()
    |> String.split()
  end

  def pick_word(path) do
    path
    |> load_word_list()
    |> Enum.random()
  end
end
