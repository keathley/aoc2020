defmodule Day4 do
  @input File.read!(Path.absname("priv/day4.txt", Application.app_dir(:aoc2020)))

  @attr_re ~r/([a-z]{3}):(.*)$/
  @height_re ~r/(\d+)(in|cm)$/

  defmodule Passport do
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

    def new(list) do
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
      fields_present?(pass)
      pass.byr

    end
  end

  def solve do
    passports = parse(@input)

    # bad count
    count = Enum.count(passports, &Passport.fields_present?/1)
    IO.puts "Part 1: #{count}"

    # Good count
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
      |> Enum.map(fn attr ->
        [_original, attr, v] = Regex.run(@attr_re, attr)
        attr = String.to_atom(attr)

        v = case attr do
          :byr -> String.to_integer(v)
          :iyr -> String.to_integer(v)
          :eyr -> String.to_integer(v)
          :hgt ->
            [_original, num, unit] = Regex.run(@height_re, v)
            {String.to_integer(num), String.to_atom(unit)}
          :hcl -> v
        end

        {attr, v}
      end)
      |> Passport.new()
    end)
  end
end
