defmodule Day2 do
  def problem1(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_entry/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&valid_password?/1)
    |> Enum.count(& &1)
  end

  def problem2(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_entry/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&valid_password2?/1)
    |> Enum.count(& &1)
  end

  defp parse_entry(str) do
    case Regex.run(~r/(\d+)-(\d+) ([a-z]): (.*)$/, str) do
      [_, min, max, char, pass] ->
        {String.to_integer(min), String.to_integer(max), char, pass}

      other ->
        nil
    end
  end

  defp valid_password?({min, max, char, password}) do
    count =
      password
      |> String.graphemes()
      |> Enum.group_by(& &1)
      |> Map.get(char, [])
      |> Enum.count()

    min <= count && count <= max
  end

  defp valid_password2?({i, j, char, password}) do
    # We need to reduce the indexes by 1 since the password validator is 1 indexed.
    i = i-1
    j = j-1
    :erlang.xor(String.at(password, i) == char, String.at(password, j) == char)
  end
end
