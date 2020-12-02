defmodule Day1 do
  def problem1(input) do
    lookup =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(& {&1, 2020-&1})
      |> Enum.into(%{})

    {v1, v2} = Enum.find(lookup, fn {v1, v2} -> Map.get(lookup, v2) end)

    v1 * v2
  end

  def problem2(input) do
    cleaned = input(input)

    lookup =
      cleaned
      |> Enum.map(& {&1, &1})
      |> Enum.into(%{})

    {v1, v2, v3} = Enum.find_value(cleaned, fn v1 ->
      Enum.find_value(cleaned, fn v2 ->
        case Map.get(lookup, 2020-v1-v2) do
          nil ->
            false

          v3 ->
            {v1, v2, v3}
        end
      end)
    end)

    v1 * v2 * v3
  end

  defp input(str) do
    str
    |> Input.clean()
    |> Enum.map(&String.to_integer/1)
  end
end
