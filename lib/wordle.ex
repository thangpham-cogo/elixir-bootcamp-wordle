defmodule Wordle do
  @moduledoc """
  Wordle game in Elixir
  """
  alias Wordle.{Game, Client, Dictionary}

  @all_words_file_path "#{File.cwd!()}/priv/all_words.txt"
  @all_secrets_file_path "#{File.cwd!()}/priv/words.txt"
  @num_of_guesses 4
  @type attempt() :: {guess :: String.t(), result :: Game.result_type()}
  @type game_state() :: %{
          last_guess_valid: boolean(),
          secret: String.t(),
          all_words: list(String.t()),
          num_of_guesses: non_neg_integer(),
          attempts: list(attempt())
        }

  def start(), do: loop(init_game_state())

  @spec init_game_state() :: game_state()
  defp init_game_state() do
    %{
      last_guess_valid: true,
      all_words: Dictionary.load_word_list(@all_words_file_path),
      secret: Dictionary.pick_word(@all_secrets_file_path),
      num_of_guesses: @num_of_guesses,
      attempts: []
    }
  end

  @spec loop(game_state()) :: :ok
  defp loop(%{secret: secret, num_of_guesses: num_of_guesses}) when num_of_guesses == 0 do
    Client.end_game(secret)
  end

  defp loop(state) do
    with guess <- Client.get_user_input(state.last_guess_valid, state.num_of_guesses),
         :ok <- Game.validate_word(guess, state.all_words) do
      case Game.process_guess(guess, state.secret) do
        :win ->
          Client.display_success(state.secret)

        {:ok, result} ->
          next_state =
            Map.merge(state, %{
              attempts: state.attempts ++ [{guess, result}],
              num_of_guesses: state.num_of_guesses - 1
            })

          Client.display_attempts(next_state.attempts)
          loop(next_state)
      end
    else
      :error ->
        loop(Map.put(state, :last_guess_valid, false))
    end
  end
end
