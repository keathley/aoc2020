defmodule Day8 do
  @input File.read!(Path.absname("priv/day8.txt", Application.app_dir(:aoc2020)))
  import Enum, only: [at: 2]

  def solve(input \\ @input) do
    ops   = parse(input)
    state = %{
      parent: self(),
      ops: ops,
      eip: 0,
      acc: 0,
      seen: MapSet.new(),
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

  def interpret(%{eip: eip, exit_loc: eip, acc: acc}) do
    {:done, acc}
  end
  def interpret(%{ops: ops, eip: eip, acc: acc}=state) do
    if MapSet.member?(state.seen, eip) do
      throw :infinite
    end

    state = update_in(state, [:seen], & MapSet.put(&1, eip))
    op    = at(ops, eip)

    case op do
      {:nop, _} ->
        interpret(%{state | eip: eip+1})

      {:acc, val} ->
        interpret(%{state | eip: eip+1, acc: acc+val})

      {:jmp, val} ->
        interpret(%{state | eip: eip+val})
    end
  catch
    :infinite ->
      {:infinite, acc}
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