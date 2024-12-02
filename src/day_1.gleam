import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let #(left, right) = parse_data("inputs/day_1.txt")

  part_one(left, right) |> io.debug
  part_two(left, right) |> io.debug
}

fn parse_data(path: String) -> #(List(Int), List(Int)) {
  let assert Ok(text) = simplifile.read(path)

  string.split(text, "\n")
  |> list.map(fn(line) {
    let assert Ok(#(left, right)) = string.split_once(line, " ")
    let assert Ok(left) = int.parse(left)
    let assert Ok(right) = int.parse(string.trim(right))
    #(left, right)
  })
  |> list.unzip
}

fn part_one(left: List(Int), right: List(Int)) -> Int {
  let sorted_left = list.sort(left, int.compare)
  let sorted_right = list.sort(right, int.compare)

  count_list_diff(sorted_left, sorted_right, 0)
}

fn count_list_diff(left: List(Int), right: List(Int), acc: Int) -> Int {
  case left, right {
    [left_int, ..left_rest], [right_int, ..right_rest] -> {
      let diff = int.absolute_value(left_int - right_int)
      count_list_diff(left_rest, right_rest, acc + diff)
    }
    _, _ -> acc
  }
}

fn part_two(left: List(Int), right: List(Int)) -> Int {
  use total_similarity, left_number <- list.fold(left, 0)
  let occurences_in_right =
    list.fold(right, 0, fn(acc, right_number) {
      case left_number == right_number {
        True -> acc + 1
        False -> acc
      }
    })
  let similarity = left_number * occurences_in_right
  total_similarity + similarity
}
