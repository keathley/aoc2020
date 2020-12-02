use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use regex::Regex;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

pub fn solve() {
    let re = Regex::new(r"(\d+)-(\d+) ([a-z]): (.*)$").unwrap();

    let lines = read_lines("data/day2.txt").unwrap()
        .map(|line| line.unwrap())
        .collect::<Vec<String>>();

    let input: Vec<(usize, usize, char, &str)> = lines.iter()
        .map(|line| {
            let captures = re.captures(&line).unwrap();
            let index1 = captures.get(1).unwrap().as_str().parse().unwrap();
            let index2 = captures.get(2).unwrap().as_str().parse().unwrap();
            let target = captures.get(3).unwrap().as_str().chars().next().unwrap();
            let password = captures.get(4).unwrap().as_str();
            (index1, index2, target, password)
        })
        .collect();

    let mut count = 0;
    for &(i, j, c, pass) in &input {
        let char_count = pass.matches(c).count();
        if i <= char_count && char_count <= j {
            count += 1;
        }
    }
    println!("Part 1: {}", count);

    let mut count = 0;
    for &(i, j, c, pass) in &input {
        let chars: Vec<char> = pass.chars().collect();
        if (chars[i-1] == c) != (chars[j-1] == c) {
            count += 1;
        }
    }
    println!("Part 2: {}", count);
}
