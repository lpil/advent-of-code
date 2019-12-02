import gleam/int
import gleam/list
import gleam/string
import gleam/result

// Calculate the fuel requirement for a module, given its mass.
//
// Fuel required to launch a given module is based on its mass. Specifically,
// to find the fuel required for a module, take its mass, divide by three,
// round down, and subtract 2.
//
// In a real application we would likely want to have mass and fuel requirement
// be different types, but for here in this small challenge we can use Int.
//
pub fn fuel_requirement(module_mass) {
  module_mass / 3 - 2
}

// We have been given the masses of our modules as a newline delimited string.
// Parse this string to list of masses.
//
pub fn parse_input_data(input) {
  input
  |> string.split(_, "\n")
  |> list.traverse(_, int.parse)
}

// Calculate the total fuel requirement for the ship given the input data
// string containing the mass of each ship module.
//
pub fn ship_fuel_requirement(input) {
  let add = fn(a, b) { a + b }

  input
  |> parse_input_data
  |> result.map(_, fn(modules) {
    modules
    |> list.map(_, fuel_requirement)
    |> list.fold(_, 0, add)
  })
}
