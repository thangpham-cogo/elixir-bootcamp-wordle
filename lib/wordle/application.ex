defmodule Wordle.Application do
  def start(_, _) do
    Wordle.start()
    {:ok, self()}
  end
end
