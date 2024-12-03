import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(text) = simplifile.read("inputs/day_3.txt")

  part_one(text) |> io.debug
  part_two(text) |> io.debug
}

fn part_one(text: String) {
  find_muls(text, [])
  |> list.map(fn(numbers) {
    let #(first, second) = numbers
    first * second
  })
  |> int.sum
}

fn part_two(text: String) {
  let enabled_text = accumulate_enabled(text, "", True)

  part_one(enabled_text)
}

fn accumulate_enabled(text: String, enabled_text: String, enabled: Bool) {
  case enabled {
    True -> {
      case string.split_once(text, "don't()") {
        Ok(#(enabled, remaining)) -> {
          accumulate_enabled(remaining, enabled_text <> enabled, False)
        }
        _ -> text <> enabled_text
      }
    }
    False -> {
      case string.split_once(text, "do()") {
        Ok(#(_, enabled)) -> {
          accumulate_enabled(enabled, enabled_text, True)
        }
        _ -> enabled_text
      }
    }
  }
}

fn find_muls(text: String, mults: List(#(Int, Int))) {
  case string.split_once(text, "mul(") {
    Ok(#(_, rest)) -> {
      case string.split_once(rest, ")") {
        Ok(#(numbers, rest)) -> {
          case string.split_once(numbers, ",") {
            Ok(#(first, second)) -> {
              case int.parse(first), int.parse(second) {
                Ok(first), Ok(second) ->
                  find_muls(rest, list.append(mults, [#(first, second)]))
                _, _ -> find_muls(numbers <> ")" <> rest, mults)
              }
            }
            _ -> find_muls(rest, mults)
          }
        }
        _ -> mults
      }
    }
    _ -> mults
  }
}
