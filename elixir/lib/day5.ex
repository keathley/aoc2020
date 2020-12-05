defmodule Day5 do
  def solve do

  end

  def to_id(str) do
    <<row :: binary-size(7), col :: binary-size(3)>> = str
    # row    = String.slice(str, 0..6)
    # column = String.slice(str, 7..9)

    row = find_row(row, 0, 127)
    # column = find_column(col)

    # row * 8 + column
  end

  def find_row(str, start, stop) do
    midpoint = div(start + (stop-1), 2)

    case str do
      <<"F", rest :: binary>> -> find_row(rest, start, midpoint)
      <<"B", rest :: binary>> -> find_row(rest, midpoint+1, stop)
      <<>> -> start
    end
  end
end
