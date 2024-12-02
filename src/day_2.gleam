import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let reports = parse_data("inputs/day_2.txt")
  part_one(reports) |> io.debug
  part_two(reports) |> io.debug
}

fn parse_data(path: String) -> List(List(Int)) {
  let assert Ok(text) = simplifile.read(path)
  string.split(text, "\n")
  |> list.map(fn(line) {
    string.split(line, " ")
    |> list.map(fn(number) {
      let assert Ok(int) = int.parse(number)
      int
    })
  })
}

fn is_increasing(report: List(Int)) {
  list.window_by_2(report)
  |> list.fold_until(True, fn(_, window) {
    let #(previous, next) = window
    case next - previous {
      1 | 2 | 3 -> list.Continue(True)
      _ -> list.Stop(False)
    }
  })
}

fn is_safe(report: List(Int)) {
  let is_safely_increasing = is_increasing(report)
  let is_safely_decreasing = is_increasing(list.reverse(report))

  is_safely_increasing || is_safely_decreasing
}

fn part_one(reports: List(List(Int))) {
  list.count(reports, is_safe)
}

fn part_two(reports: List(List(Int))) {
  reports
  |> list.count(fn(report) {
    list.combinations(report, list.length(report) - 1)
    |> list.any(is_safe)
  })
}
