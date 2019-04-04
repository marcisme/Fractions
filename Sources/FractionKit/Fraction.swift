import Foundation

// TODO: consider extracting to separate type
private func isNumeric(_ string: String) -> Bool {
  let regex = try! NSRegularExpression(pattern: "^\\d+$")
  return regex.numberOfMatches(in: string, range: NSMakeRange(0, string.count)) > 0
}

public struct Fraction: Equatable {
  public enum NumericComponentType: Equatable {
    case whole
    case numerator
    case denominator
  }

  public enum Error: Swift.Error, Equatable {
    case emptyString
    case invalid(NumericComponentType)
    case outOfBounds(NumericComponentType)
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
      self.whole = try parseInt(String(parts[0]), type: .whole)
      self.numerator = 0
      self.denominator = 0
    case 2:
      self.whole = 0
      self.numerator = try parseInt(String(parts[0]), type: .numerator)
      self.denominator = try parseInt(String(parts[1]), type: .denominator)
    case 3:
      self.whole = try parseInt(String(parts[0]), type: .whole)
      self.numerator = try parseInt(String(parts[1]), type: .numerator)
      self.denominator = try parseInt(String(parts[2]), type: .denominator)
    default:
      fatalError("expected 1, 2 or 3 parts")
    }
  }
}

// this is slightly less awkward than using a class method
fileprivate func parseInt(_ string: String, type: Fraction.NumericComponentType) throws -> Int {
  if let int = Int(string) {
    return int
  }

  if isNumeric(string) {
    throw Fraction.Error.outOfBounds(type)
  } else {
    throw Fraction.Error.invalid(type)
  }
}

