defmodule Day4 do
  @input File.read!(Path.absname("priv/day4.txt", Application.app_dir(:aoc2020)))

  def solve do
    @input
    |> parse
  end

  def parse(str) do
    passports =
      str
      |> String.split("\n")
      |> Enum.chunk_by(fn line -> line == "" end)

    parsed =
      passports
      |> Enum.map(fn p ->
        for item <- p, do: 
      end)
  end
end
