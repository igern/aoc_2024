import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import simplifile

pub type Rule =
  #(String, String)

pub type Update =
  List(String)

pub fn main() {
  let #(rules, updates) = parse_data("inputs/day_5.txt")

  part_one(rules, updates) |> io.debug
  part_two(rules, updates) |> io.debug
}

fn parse_data(path: String) -> #(List(Rule), List(Update)) {
  let assert Ok(text) = simplifile.read(path)

  let assert Ok(#(rules, updates)) = string.split_once(text, "\n\n")

  let rules =
    string.split(rules, "\n")
    |> list.map(fn(rule) {
      let assert Ok(#(left, right)) = string.split_once(rule, "|")
      #(left, right)
    })
  let updates =
    string.split(updates, "\n")
    |> list.map(fn(line) { string.split(line, ",") })
  #(rules, updates)
}

fn part_one(rules: List(Rule), updates: List(Update)) -> Int {
  list.fold(updates, 0, fn(acc, update) {
    case apply_rules_to_update(update, rules) {
      True -> {
        let middle =
          list.drop(update, list.length(update) / 2)
          |> list.first
          |> result.try(int.parse)
          |> result.unwrap(0)
        acc + middle
      }
      False -> acc
    }
  })
}

fn apply_rules_to_update(update: Update, rules: List(Rule)) -> Bool {
  case rules {
    [rule, ..rest] -> {
      case index_of(update, rule.0, 0), index_of(update, rule.1, 0) {
        Ok(left), Ok(right) -> {
          case left < right {
            True -> apply_rules_to_update(update, rest)
            False -> False
          }
        }
        _, _ -> apply_rules_to_update(update, rest)
      }
    }

    [] -> True
  }
}

fn index_of(list: List(a), element: a, index: Int) -> Result(Int, Nil) {
  case list {
    [e, ..rest] -> {
      case e == element {
        True -> Ok(index)
        False -> index_of(rest, element, index + 1)
      }
    }
    [] -> Error(Nil)
  }
}

fn part_two(rules: List(Rule), updates: List(Update)) -> Int {
  let compare = fn(a: String, b: String) -> order.Order {
    let rule =
      list.find(rules, fn(rules) {
        let #(left, right) = rules
        left == a && right == b || right == a && left == b
      })

    case rule {
      Ok(#(left, _)) -> {
        case left == a {
          True -> order.Lt
          False -> order.Gt
        }
      }
      Error(_) -> order.Eq
    }
  }

  list.filter(updates, fn(update) {
    case apply_rules_to_update(update, rules) {
      True -> False
      False -> True
    }
  })
  |> list.map(fn(update) {
    list.sort(update, compare)
    |> list.drop(list.length(update) / 2)
    |> list.first
    |> result.try(int.parse)
    |> result.unwrap(0)
  })
  |> int.sum
}
