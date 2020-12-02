extern crate regex;

mod day1;
mod day2;

fn main() {
    println!("Part 1: {}", day1::part1());
    println!("Part 2: {}", day1::part2());

    println!("Day 2");
    day2::solve();
}
