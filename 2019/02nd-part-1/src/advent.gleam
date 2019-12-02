external type Array(element);

external fn list_to_array(List(a), a) -> Array(a) = "array" "from_list";

external fn array_to_list(Array(a)) -> List(a) = "array" "to_list";

external fn get(Int, Array(a)) -> a = "array" "get";

external fn set(Int, a, Array(a)) -> Array(a) = "array" "set";

fn eval(opcodes, instruction_pointer) {
  let do = fn(f) {
    let in_pointer1 = get(instruction_pointer + 1, opcodes)
    let in_pointer2 = get(instruction_pointer + 2, opcodes)
    let out_pointer = get(instruction_pointer + 3, opcodes)
    let in1 = get(in_pointer1, opcodes)
    let in2 = get(in_pointer2, opcodes)
    let out = f(in1, in2)
    let new_opcodes = set(out_pointer, out, opcodes)
    eval(new_opcodes, instruction_pointer + 4)
  }

  case get(instruction_pointer, opcodes) {
    1 -> do(fn(a, b) { a + b })
    2 -> do(fn(a, b) { a * b })
    _ -> opcodes
  }
}

pub fn main(opcodes_list) {
  list_to_array(opcodes_list, 99)
  |> eval(_, 0)
  |> array_to_list
}
