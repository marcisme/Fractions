import FractionKit

let parser = LineParser()
print("? ", terminator: "")
while let input = readLine() {
  print("= ", terminator: "")
  do {
    let operation = try parser.parse(input)
    let fraction = try operation.execute()
    print(fraction.simplify.uiDescription)
  } catch {
    print(error.localizedDescription)
  }
  print("\n? ", terminator: "")
}
