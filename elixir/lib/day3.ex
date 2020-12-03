defmodule Day3 do
  @input File.read!(Path.absname("priv/day3.txt", Application.app_dir(:aoc2020)))

  def solve(str \\ @input) do
    map = build_map(str)

    tree_count = carve_path(map, {0, 0}, {3, 1}, 0)
    IO.puts "Part 1: #{tree_count}"

    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2},
    ]
    count =
      slopes
      |> Enum.map(fn slope -> carve_path(map, {0, 0}, slope, 0) end)
      |> Enum.reduce(& &1 * &2)

    IO.puts "Part 2: #{count}"
  end

  defp carve_path(map, {x, y}=point, {sx, sy}=slope, count) do
    # We need to wrap around if we've gone beyond the edge of the x coordinate
    # the map size is 31 characters wide. So we wrap once we get there.
    next = {rem(x+sx, 31), y+sy}

    # If we get nil we assume we're off the map and return the count
    case map[point] do
      "." -> carve_path(map, next, slope, count)
      "#" -> carve_path(map, next, slope, count+1)
      nil -> count
    end
  end

  # Turn a string representation of the map into a map of keys {x, y} to values
  # "." | "#".
  defp build_map(str) do
    str
    |> String.split()
    |> Enum.map(& String.graphemes(&1))
    |> Enum.map(& Enum.with_index(&1))
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} -> Enum.map(row, fn {c, x} -> {{x, y}, c} end) end)
    |> Enum.into(%{})
  end
end
