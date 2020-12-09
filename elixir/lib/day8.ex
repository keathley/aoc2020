defmodule Day8 do
  @input File.read!(Path.absname("priv/day8.txt", Application.app_dir(:aoc2020)))
  import Enum, only: [at: 2]

  def solve(input \\ @input) do
    ops   = parse(input)
    state = %{
      ops: ops,
      eip: 0,
      acc: 0,
      seen: [],
      exit_loc: Enum.count(ops),
    }
    t = Task.async(fn -> interpret(state) end)
    {:infinite, result} = Task.await(t)
    IO.puts "Part 1: #{result}"

    result =
      state
      |> mutate_instructions()
      |> Enum.map(fn m -> Task.async(fn -> interpret(m) end) end)
      |> Enum.map(&Task.await/1)
      |> Enum.find_value(fn
        {:done, acc}      -> acc
        {:infinite, _acc} -> false
      end)
    IO.puts "Part 2: #{result}"
  end

  # If eip has reached the exit loc, we know that we're done. Otherwise, if
  # we've already seen an eip before, we know that we're in a loop so we say that
  # we're going infinite. Otherwise we proceed as normal.
  def interpret(%{eip: eip, exit_loc: eip, acc: acc}), do: {:done, acc}
  def interpret(%{ops: ops, eip: eip, seen: seen, acc: acc}=state) do
    if eip in seen do
      {:infinite, acc}
    else
      state = %{state | seen: [eip | seen]}
      op    = at(ops, eip)

      case op do
        {:nop, _} ->
          interpret(%{state | eip: eip+1})

        {:acc, val} ->
          interpret(%{state | eip: eip+1, acc: acc+val})

        {:jmp, val} ->
          interpret(%{state | eip: eip+val})
      end
    end
  end

  defp mutate_instructions(%{ops: ops}=state) do
    mutations = for i <- 0..Enum.count(ops)-1 do
      case at(ops, i) do
        {:nop, _} -> %{state | ops: flip(ops, i)}
        {:jmp, _} -> %{state | ops: flip(ops, i)}
        _         -> :skip
      end
    end
    Enum.reject(mutations, & &1 == :skip)
  end

  defp flip(ops, i) do
    update_in(ops, [Access.at(i)], fn op ->
      case op do
        {:nop, val} -> {:jmp, val}
        {:jmp, val} -> {:nop, val}
      end
    end)
  end

  def parse(str \\ @input) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_op/1)
  end

  defp parse_op(str) do
    [_original, op, sign, num] = Regex.run(~r/([a-z]{3}) ([+-])(\d+)/, str)
    num = String.to_integer(num)
    num = if sign == "-", do: num * -1, else: num
    op  = String.to_atom(op)
    {op, num}
  end
end
