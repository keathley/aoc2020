defmodule Day8 do
  @input File.read!(Path.absname("priv/day8.txt", Application.app_dir(:aoc2020)))

  import Enum, only: [at: 2]

  def solve(input \\ @input) do
    ops = parse(input)
    state = %{ops: ops, eip: 0, acc: 0, seen: MapSet.new()}
    interpret(state)
  end

  def interpret(%{ops: ops, eip: eip, acc: acc}=state) do
    if MapSet.member?(state.seen, eip) do
      IO.puts "Beginning Loop: #{acc}"
      throw :exit
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
