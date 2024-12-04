import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/string
import simplifile

type Direction {
  RightUp
  Right
  RightDown
  Down
  LeftDown
  Left
  LeftUp
  Up
}

type Grid(a) =
  Dict(Point, a)

type Point =
  #(Int, Int)

pub fn main() {
  let grid = parse_data("inputs/day_4.txt")

  part_one(grid) |> io.debug
  part_two(grid) |> io.debug
}

fn part_one(grid: Grid(String)) -> Int {
  let x_dict = dict.filter(grid, fn(_, value) { value == "X" })
  use count, pos, _letter <- dict.fold(x_dict, 0)
  count + check_for_xmas(grid, pos)
}

fn check_for_xmas(grid: Grid(String), pos: Point) -> Int {
  use count, direction <- list.fold(
    [RightUp, Right, RightDown, Down, LeftDown, Left, LeftUp, Up],
    0,
  )

  case check_direction_for_xmas(grid, pos, direction) {
    True -> count + 1
    False -> count
  }
}

fn check_direction_for_xmas(
  grid: Grid(String),
  pos: Point,
  direction: Direction,
) -> Bool {
  case direction {
    RightUp -> {
      case
        dict.get(grid, #(pos.0 + 1, pos.1 - 1)),
        dict.get(grid, #(pos.0 + 2, pos.1 - 2)),
        dict.get(grid, #(pos.0 + 3, pos.1 - 3))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
    Right -> {
      case
        dict.get(grid, #(pos.0 + 1, pos.1)),
        dict.get(grid, #(pos.0 + 2, pos.1)),
        dict.get(grid, #(pos.0 + 3, pos.1))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
    RightDown -> {
      case
        dict.get(grid, #(pos.0 + 1, pos.1 + 1)),
        dict.get(grid, #(pos.0 + 2, pos.1 + 2)),
        dict.get(grid, #(pos.0 + 3, pos.1 + 3))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
    Down -> {
      case
        dict.get(grid, #(pos.0, pos.1 + 1)),
        dict.get(grid, #(pos.0, pos.1 + 2)),
        dict.get(grid, #(pos.0, pos.1 + 3))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
    LeftDown -> {
      case
        dict.get(grid, #(pos.0 - 1, pos.1 + 1)),
        dict.get(grid, #(pos.0 - 2, pos.1 + 2)),
        dict.get(grid, #(pos.0 - 3, pos.1 + 3))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
    Left -> {
      case
        dict.get(grid, #(pos.0 - 1, pos.1)),
        dict.get(grid, #(pos.0 - 2, pos.1)),
        dict.get(grid, #(pos.0 - 3, pos.1))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
    LeftUp -> {
      case
        dict.get(grid, #(pos.0 - 1, pos.1 - 1)),
        dict.get(grid, #(pos.0 - 2, pos.1 - 2)),
        dict.get(grid, #(pos.0 - 3, pos.1 - 3))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
    Up -> {
      case
        dict.get(grid, #(pos.0, pos.1 - 1)),
        dict.get(grid, #(pos.0, pos.1 - 2)),
        dict.get(grid, #(pos.0, pos.1 - 3))
      {
        Ok("M"), Ok("A"), Ok("S") -> True
        _, _, _ -> False
      }
    }
  }
}

fn parse_data(path: String) {
  let assert Ok(text) = simplifile.read(path)

  string.split(text, "\n")
  |> list.index_map(fn(line, y) {
    string.to_graphemes(line)
    |> list.index_map(fn(character, x) { #(#(x, y), character) })
  })
  |> list.flatten
  |> dict.from_list
}

fn part_two(grid: Grid(String)) -> Int {
  let a_dict = dict.filter(grid, fn(_, value) { value == "A" })
  use count, point, _letter <- dict.fold(a_dict, 0)

  case check_for_x_mas(grid, point) {
    True -> count + 1
    False -> count
  }
}

fn check_for_x_mas(grid: Grid(String), pos: Point) -> Bool {
  case
    dict.get(grid, #(pos.0 + 1, pos.1 - 1)),
    dict.get(grid, #(pos.0 + 1, pos.1 + 1)),
    dict.get(grid, #(pos.0 - 1, pos.1 + 1)),
    dict.get(grid, #(pos.0 - 1, pos.1 - 1))
  {
    Ok("M"), Ok("M"), Ok("S"), Ok("S") -> True
    Ok("S"), Ok("M"), Ok("M"), Ok("S") -> True
    Ok("S"), Ok("S"), Ok("M"), Ok("M") -> True
    Ok("M"), Ok("S"), Ok("S"), Ok("M") -> True
    _, _, _, _ -> False
  }
}
