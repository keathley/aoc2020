defmodule Day7 do
  @input File.read!(Path.absname("priv/day7.txt", Application.app_dir(:aoc2020)))

  def solve(input \\ @input) do
    graph = build_graph(input)

    part1 = Enum.count(graph, fn {key, _inner} ->
      # Don't count ourselves
      if key == "shiny gold" do
        false
      else
        reachable?(graph, key, "shiny gold")
      end
    end)
    IO.puts "Part 1: #{part1}"

    part2 = recursive_count(graph, "shiny gold")
    IO.puts "Part 2: #{part2}"
  end

  def recursive_count(graph, key) do
    case graph[key] do
      [] -> 0

      inner ->
        Enum.reduce(inner, 0, fn {inner_key, weight}, acc ->
          acc + weight + (weight * recursive_count(graph, inner_key))
        end)
    end
  end

  def build_graph(input \\ @input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> to_graph(%{})
  end

  # If the key and target match, then we found ourself
  def reachable?(_, target, target), do: true
  def reachable?(graph, key, target) do
    case graph[key] do
      [] ->
        false

      inner ->
        Enum.any?(inner, fn {inner_key, _weight} ->
          reachable?(graph, inner_key, target)
        end)
    end
  end

  def to_graph([], acc) do
    acc
  end
  def to_graph([{key, inner} | entries], acc) do
    to_graph(entries, Map.update(acc, key, inner, & inner ++ &1))
  end

  def parse(str) do
    tokens = tokenize(str)
    [adj, color, "bags", "contain" | tokens] = tokens
    inner_bags = parse_inner(tokens, [])
    {to_key(adj, color), inner_bags}
  end

  defp parse_inner(["no", "other", "bags", "."], acc) do
    acc
  end
  defp parse_inner([count, adj, color, _bag, "."], acc) do
    [{to_key(adj, color), String.to_integer(count)} | acc]
  end
  defp parse_inner([count, adj, color, _bag, "," | tokens], acc) do
    parse_inner(tokens, [{to_key(adj, color), String.to_integer(count)} | acc])
  end

  defp tokenize(str) do
    tokens = Regex.split(~r/[\s,.]/, str, include_captures: true, trim: true)
    Enum.reject(tokens, & &1 == " ")
  end

  defp to_key(adj, color), do: "#{adj} #{color}"
end
