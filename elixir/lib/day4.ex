defmodule Day4 do
  @input File.read!(Path.absname("priv/day4.txt", Application.app_dir(:aoc2020)))

  defmodule Passport do
    @attr_re ~r/([a-z]{3}):(.*)$/
    @height_re ~r/(\d+)(in|cm)$/
    @pid_re ~r/^\d{9}$/
    @hex_re ~r/^#([a-z0-9]{6})$/

    defstruct [
      byr: nil,
      iyr: nil,
      eyr: nil,
      hgt: nil,
      hcl: nil,
      ecl: nil,
      pid: nil,
      cid: nil,
    ]

    def parse(list) do
      list
      |> Enum.map(&parse_attr/1)
      |> new()
    end

    defp parse_attr(attr) do
      [_original, attr, v] = Regex.run(@attr_re, attr)
      attr = String.to_atom(attr)

      v = case attr do
        :byr -> to_i(v)
        :iyr -> to_i(v)
        :eyr -> to_i(v)
        :hgt ->
          case Regex.run(@height_re, v) do
            [_original, num, unit]  ->
              {String.to_integer(num), String.to_atom(unit)}

            _ ->
              nil
          end
        :hcl ->
          if Regex.match?(@hex_re, v), do: v
        :ecl ->
          if v in ~w(amb blu brn gry grn hzl oth), do: String.to_atom(v)
        :pid ->
          if Regex.match?(@pid_re, v), do: v
        :cid -> v
      end

      {attr, v}
    end

    defp new(list) do
      struct(__MODULE__, list)
    end

    def fields_present?(pass) do
      pass.byr &&
      pass.iyr &&
      pass.eyr &&
      pass.hgt &&
      pass.hcl &&
      pass.ecl &&
      pass.pid
    end

    defp to_i(s) do
      String.to_integer(s)
    rescue
      _ ->
        nil
    end

    # byr (Birth Year) - four digits; at least 1920 and at most 2002.
    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    # hgt (Height) - a number followed by either cm or in:
    #   - If cm, the number must be at least 150 and at most 193.
    #   - If in, the number must be at least 59 and at most 76.
    # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    # cid (Country ID) - ignored, missing or not.
    def valid?(pass) do
      fields_present?(pass) &&
      (1920 <= pass.byr && pass.byr <= 2002) &&
      (2010 <= pass.iyr && pass.iyr <= 2020) &&
      (2020 <= pass.eyr && pass.eyr <= 2030) &&
      valid_height?(pass)
    end

    defp valid_height?(%{hgt: {val, unit}}) do
      case unit do
        :cm -> 150 <= val && val <= 193
        :in -> 59  <= val && val <= 76
      end
    end
  end

  def solve do
    passports = parse(@input)

    # This count is now broken because we do validation in the parsing logic
    # as the Dark Lord intended.
    count = Enum.count(passports, &Passport.fields_present?/1)
    IO.puts "Part 1: #{count}"

    count2 = Enum.count(passports, &Passport.valid?/1)
    IO.puts "Part2: #{count2}"
  end

  def parse(str) do
    str
    |> String.split("\n")
    |> Enum.chunk_by(fn line -> line == "" end)
    |> Enum.reject(& &1 == [""])
    |> Enum.map(fn group ->
      group
      |> Enum.flat_map(fn str -> String.split(str) end)
      |> Passport.parse()
    end)
  end
end
