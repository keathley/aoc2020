defmodule Day7 do
  @input File.read!(Path.absname("priv/day7.txt", Application.app_dir(:aoc2020)))

  def solve do
    @input
    |> String.split("\n")
    |> parse()
  end

  def parse(str) do
    tokens = tokenize(str)
    [adj, color, "contains" | tokens] = tokens
  end

  defp tokenize(str) do
    tokens = Regex.split(~r/[\s,.]/, str, include_captures: true, trim: true)
    Enum.reject(tokens, & &1 == " ")
  end
end
