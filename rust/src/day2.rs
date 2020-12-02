use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use regex::Regex;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

enum Policy {
    Old,
    New
}

#[derive(Debug)]
struct Line {
    index1: usize,
    index2: usize,
    target_char: char,
    password: String,
}

impl Line {
    fn is_valid(&self, policy: Policy) -> bool {
        match policy {
            Policy::Old => {
                let mut count = 0;
                for c in self.password.chars() {
                    if c == self.target_char {
                        count += 1;
                    }
                }
                self.index1 <= count && count <= self.index2
            }

            Policy::New => {
                let first  = self.password.chars().nth(self.index1-1);
                let second = self.password.chars().nth(self.index2-1);

                match (first, second) {
                    (Some(first), Some(second)) => {
                        return xor(first == self.target_char, second == self.target_char)
                    }
                    _ => {
                        return false;
                    }
                }
            }
        }
    }
}

fn xor(a: bool, b: bool) -> bool {
    (a && !b) || (b && !a)
}

pub fn solve() {
    let re = Regex::new(r"(\d+)-(\d+) ([a-z]): (.*)$").unwrap();

    let lines: Vec<Line> = read_lines("data/day2.txt").unwrap()
        .map(|line| line.unwrap())
        .map(|line| {
            let captures = re.captures(&line).unwrap();
            Line{
                index1: captures.get(1).unwrap().as_str().parse::<usize>().unwrap(),
                index2: captures.get(2).unwrap().as_str().parse::<usize>().unwrap(),
                target_char: captures.get(3).unwrap().as_str().to_string().chars().nth(0).unwrap(),
                password: captures.get(4).unwrap().as_str().to_string()
            }
        })
        .collect();

    let count = lines.iter()
        .filter(|line| line.is_valid(Policy::Old))
        .count();

    println!("Part 1: {}", count);

    let count = lines.iter()
        .filter(|line| line.is_valid(Policy::New))
        .count();
    println!("Part 2: {}", count);
}
