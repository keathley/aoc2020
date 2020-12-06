defmodule Day5 do
  @input File.read!(Path.absname("priv/day5.txt", Application.app_dir(:aoc2020)))

  def solve do
    ids =
      @input
      |> String.split()
      |> Enum.map(&to_id/1)

    part1 = Enum.max(ids)
    IO.puts "Part 1: #{part1}"

    start    = Enum.min(ids)
    stop     = Enum.max(ids)
    expected = MapSet.new(start..stop)
    actual   = MapSet.new(ids)
    part2    = MapSet.difference(expected, actual)
    IO.puts "Part 2: #{Enum.at(Enum.to_list(part2), 0)}"
  end

  def to_id(str) do
    <<row :: binary-size(7), col :: binary-size(3)>> = str
    row = for char <- String.graphemes(row), do: (if char == "F", do: :lower, else: :upper)
    col = for char <- String.graphemes(col), do: (if char == "L", do: :lower, else: :upper)

    row = find_spot(row, 0, 127)
    col = find_spot(col, 0, 7)

    row * 8 + col
  end

  def find_spot(moves, start, stop) do
    midpoint = div(start + (stop-1), 2)

    case moves do
      [:lower | rest] -> find_spot(rest, start, midpoint)
      [:upper | rest] -> find_spot(rest, midpoint+1, stop)
      [] -> start
    end
  end
end
