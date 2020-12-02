extern crate regex;

mod day1;
mod day2;

fn main() {
    println!("\nDay 1");
    println!("Part 1: {}", day1::part1());
    println!("Part 2: {}", day1::part2());

    println!("\nDay 2");
    day2::solve();
}
