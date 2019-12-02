import gleam/list

// Calculate the fuel requirement to transport a given mass
//
pub fn fuel_requirement(mass, total) {
  let fuel = mass / 3 - 2

  case fuel > 0 {
    True -> fuel_requirement(fuel, total + fuel)
    False -> total
  }
}

pub fn ship_fuel_requirement(modules) {
  list.fold(modules, 0, fuel_requirement)
}
