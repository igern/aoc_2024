import gleam/dict
import gleam/io
import gleam/list
import gleam/string
import simplifile

type Pos =
  #(Int, Int)

type Character =
  #(Pos, String)

type Map(a) =
  dict.Dict(Pos, a)

pub fn main() {
  let map =
    parse_data("inputs/day_6_test.txt")
    |> io.debug
}

fn parse_data(path: String) -> Map(String) {
  let assert Ok(text) = simplifile.read(path)

  string.split(text, "\n")
  |> list.index_map(fn(line, y) {
    string.to_graphemes(line)
    |> list.index_map(fn(character, x) { #(#(x, y), character) })
  })
  |> list.flatten
  |> dict.from_list
}

fn guard_position(map: Map(String)) -> Pos {
  dict.to_list(map)
  |> list.find(fn(entry) {
    let #(pos, character) = entry
    character == "^" || character == ">" || character == "v" || character == "<"
  })

  #(0, 0)
}
