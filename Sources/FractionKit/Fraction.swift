import Foundation

// TODO: consider extracting to separate type
private func isNumeric(_ string: String) -> Bool {
  let regex = try! NSRegularExpression(pattern: "^\\d+$")
  return regex.numberOfMatches(in: string, range: NSMakeRange(0, string.count)) > 0
}

private func parseInt(_ string: String, invalid: Fraction.Error, oob: Fraction.Error) throws -> Int {
  if let int = Int(string) {
    return int
  }

  if isNumeric(string) {
    throw oob
  } else {
    throw invalid
  }
}

public struct Fraction: Equatable {
  // TODO: consider an associated value for the numeric component types
  public enum Error: Swift.Error {
    case emptyString
    case invalidWholeNumber
    case invalidNumerator
    case invalidDenominator
    case outOfBoundsNumber
    case outOfBoundsNumerator
    case outOfBoundsDenominator
  }

  let whole: Int
  let numerator: Int
  let denominator: Int

  public init(whole: Int, numerator: Int, denominator: Int) {
    self.whole = whole
    self.numerator = numerator
    self.denominator = denominator
  }

  public init(string: String) throws {
    guard string.count > 0 else {
      throw Error.emptyString
    }

    let parts = string.split(whereSeparator: { ["_", "/"].contains($0) })

    switch parts.count {
    case 1:
      self.whole = try parseInt(String(parts[0]), invalid: .invalidWholeNumber, oob: .outOfBoundsNumber)
      self.numerator = 0
      self.denominator = 0
    case 2:
      self.whole = 0
      self.numerator = try parseInt(String(parts[0]), invalid: .invalidNumerator, oob: .outOfBoundsNumerator)
      self.denominator = try parseInt(String(parts[1]), invalid: .invalidDenominator, oob: .outOfBoundsDenominator)
    case 3:
      self.whole = try parseInt(String(parts[0]), invalid: .invalidWholeNumber, oob: .outOfBoundsNumber)
      self.numerator = try parseInt(String(parts[1]), invalid: .invalidNumerator, oob: .outOfBoundsNumerator)
      self.denominator = try parseInt(String(parts[2]), invalid: .invalidDenominator, oob: .outOfBoundsDenominator)
    default:
      fatalError("expected 1, 2 or 3 parts")
    }
  }
}
