public struct LineParser {
  public enum Error: Swift.Error {
    case emptyLine
    case invalidInput
  }

  public init() {
  }

  public func parse(_ input: String) throws -> InfixOperation {
    guard input.count > 0 else {
      throw Error.emptyLine
    }

    let parts = try cleanAndSplit(input)

    let left = try Fraction(string: String(parts[0]))
    let op = String(parts[1])
    let right = try Fraction(string: String(parts[2]))

    return try InfixOperation.operation(for: op, left: left, right: right)
  }

  private func cleanAndSplit(_ input: String) throws -> [Substring] {
    let cleanedInput = input.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    let parts = cleanedInput.split(separator: " ")

    guard parts.count == 3 else {
      throw Error.invalidInput
    }

    return parts
  }
}
