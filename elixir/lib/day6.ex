defmodule Day6 do
  @input File.read!(Path.absname("priv/day6.txt", Application.app_dir(:aoc2020)))
  @all_answers MapSet.new(Enum.map(?a..?z, & List.to_string([&1])))

  def solve() do
    groups =
      @input
      |> String.split("\n")
      |> Enum.chunk_by(fn line -> line == "" end)
      |> Enum.reject(& &1 == [""])

    part1 = count_answers(groups, fn set, acc ->
      MapSet.union(acc, set)
    end)
    IO.puts "Part 1: #{part1}"

    part2 = count_answers(groups, @all_answers, fn set, acc ->
      MapSet.intersection(acc, set)
    end)
    IO.puts "Part 2: #{part2}"
  end

  def count_answers(groups, initial \\ MapSet.new(), f) do
    counts = for group <- groups do
      sets = for answer <- group, do: MapSet.new(String.graphemes(answer))
      set = Enum.reduce(sets, initial, f)
      Enum.count(set)
    end
    Enum.sum(counts)
  end
end
