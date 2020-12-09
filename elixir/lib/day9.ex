defmodule Day9 do
  @input File.read!(Path.absname("priv/day9.txt", Application.app_dir(:aoc2020)))

  def solve(input \\ @input, previous_count \\ 25) do
    nums =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    indexed = Enum.into(Enum.with_index(nums), %{}, fn {v, i} -> {i, v} end)

    checks = for i <- previous_count..length(nums)-1 do
      # this is some nonsense. We create map of individual numbers to
      # a map of the previous 25 numbers to the target number minus each previous
      # number...yeah...
      # Something like this:
      #   %{
      #     127 => %{
      #       95 => 32
      #       102 => 25
      #       117 => 3
      #       150 => -23
      #       182 => -55
      #     }
      #   }
      # This lets us do an easy lookup to see if the number is valid or not.
      num         = indexed[i]
      previous_25 = for j <- (i-previous_count..i-1),
        do: {indexed[j], num - indexed[j]},
        into: %{}
      {num, previous_25}
    end

    # Find the incorrect number by checking the previous 25 and doing a map lookup.
    # We already did the necessary math in the previous step.
    {answer, _} = Enum.find(checks, fn {_num, previous} ->
      !Enum.any?(previous, fn {_v1, v2} -> Map.get(previous, v2) end)
    end)
    IO.puts "Part 1: #{answer}"

    {start, stop} = find_set(indexed, answer)
    range =
      (start..stop)
      |> Enum.map(& indexed[&1])

    answer = Enum.min(range) + Enum.max(range)
    IO.puts "Part 2: #{answer}"
  end

  def find_set(nums, target), do: find_set(nums, 0, target, 0, 0)

  def find_set(nums, current, target, start, i) do
    next    = nums[i]
    current = current + next

    cond do
      current < target ->
        find_set(nums, current, target, start, i+1)

      current > target ->
        find_set(nums, 0, target, start+1, start+1)

      true ->
        {start, i}
    end
  end
end
