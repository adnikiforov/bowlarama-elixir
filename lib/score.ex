defmodule Score do
  @moduledoc """
  Handle scores calculations, including strikes and spares.
  """

  @doc """
  Convert and validate conversion of string rolls into number rolls to do proper aritmethic.
  """
  def convert_to_numbers(rolls), do: rolls |> Enum.map(&validate/1)

  @doc """
  Calculates scores for a player's pinfalls.

  It considers strikes and spares rules.

  ## Examples

  For a list of scores like this one:

      [[10,0], [7,3], [9,0], [10,0], [0,8], [8,2], [0,6], [10,0], [10,0], [0,10,8]]

  It'll return a final calculation:

      [20, 30, 39, 57, 65, 75, 81, 101, 121, 139]
  ## Examples
    iex> calculate( [[10,0], [7,3], [9,0], [10,0], [0,8], [8,2], [0,6], [10,0], [10,0], [0,10,8]])
    [20, 30, 39, 57, 65, 75, 81, 101, 121, 139]
  """
  def calculate(rolls) do
    calculate(rolls, [])
  end

  defp validate("F"), do: 0

  defp validate(roll) do
    r = String.to_integer(roll)

    if r < 0 || r > 10 do
      raise(InvalidRollError, message: "Invalid roll #{r}")
    else
      r
    end
  end

  # For Strikes and empty result list
  defp calculate([[10, sec | _], [n1, n2 | _] | rest], []) do
    calculate([[n1, n2] | rest], [fst + sec + n1 + n2])
  end

  # For Spares and empty result list
  defp calculate([[fst, sec | _], [n1 | frame] | rest], []) when fst + sec == 10 do
    calculate([[n1 | frame] | rest], [fst + sec + n1])
  end

  defp calculate([[fst, sec | _] | rest], []) do
    calculate(rest, [fst + sec])
  end

  # For Strikes
  defp calculate([[fst, sec | _], [n1, n2 | _] | rest], [ff | tail]) when fst == 10 do
    next_score = ff + fst + sec + n1 + n2

    calculate([[n1, n2] | rest], [next_score, ff | tail])
  end

  # For Spares
  defp calculate([[fst, sec | _], [n1 | frame] | rest], [ff | tail]) when fst + sec == 10 do
    next_score = ff + fst + sec + n1

    calculate([[n1 | frame] | rest], [next_score, ff | tail])
  end

  defp calculate([[fst, sec | _] | rest], [ff | r]) do
    next_score = ff + fst + sec

    calculate(rest, [next_score, ff | r])
  end

  defp calculate([], result) do
    Enum.reverse(result)
  end
end
