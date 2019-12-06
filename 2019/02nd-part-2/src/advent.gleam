import gleam/result

external type Array(element);

external fn list_to_array(List(a), a) -> Array(a) = "array" "from_list";

external fn array_to_list(Array(a)) -> List(a) = "array" "to_list";

external fn get(Int, Array(a)) -> a = "array" "get";

external fn set(Int, a, Array(a)) -> Array(a) = "array" "set";

fn eval(memory, instruction_pointer) {
  let do = fn(operation) {
    let arg_a_pointer = get(instruction_pointer + 1, memory)
    let arg_b_pointer = get(instruction_pointer + 2, memory)
    let out_pointer = get(instruction_pointer + 3, memory)
    let arg_a = get(arg_a_pointer, memory)
    let arg_b = get(arg_b_pointer, memory)
    let out = operation(arg_a, arg_b)
    let new_opcodes = set(out_pointer, out, memory)
    eval(new_opcodes, instruction_pointer + 4)
  }

  case get(instruction_pointer, memory) {
    1 -> do(fn(a, b) { a + b })
    2 -> do(fn(a, b) { a * b })
    _ -> memory
  }
}

fn eval_with_modification(memory, noun, verb) {
  memory
  |> set(1, noun, _)
  |> set(2, verb, _)
  |> eval(_, 0)
  |> get(0, _)
}

fn next_candidate(noun, verb) {
  case noun >= 99, verb >= 99 {
    True, True -> Error(Nil)
    _, True -> Ok(struct(noun + 1, 0))
    _, False -> Ok(struct(noun, verb + 1))
  }
}

fn search(memory, noun, verb) {
  case eval_with_modification(memory, noun, verb) {
    19690720 ->
      Ok(struct(noun, verb))

    _ ->
      next_candidate(noun, verb)
      |> result.then(_, fn(tup) {
        let struct(noun, verb) = tup
        search(memory, noun, verb)
      })
  }
}

pub fn main(memory) {
  memory
  |> list_to_array(_, 99)
  |> search(_, 0, 0)
  |> result.map(_, fn(tup) {
    let struct(noun, verb) = tup
    100 * noun + verb
  })
}
