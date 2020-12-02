use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::HashMap;

pub fn part1() -> i32 {
    let mut answer = 0;
    let nums = input();
    let mut lookup: HashMap<i32, i32> = HashMap::new();

    for n in &nums {
        lookup.insert(*n, 2020-n);
    }

    for n in &nums {
        if let Some(n2) = lookup.get(&n) {
            if lookup.contains_key(n2) {
                answer = n * n2;
                break;
            }
        }
    }

    answer
}

pub fn part2() -> i32 {
    let nums = input();

    for n in &nums {
        for m in &nums {
            for o in &nums {
                if n + m + o == 2020 {
                    return n * m * o;
                }
            }
        }
    }

    return 0;
}

fn input() -> Vec<i32> {
    read_lines("data/day1.txt").unwrap()
        .map(|line| line.unwrap())
        .map(|line| line.parse::<i32>().unwrap())
        .collect::<Vec<i32>>()
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
