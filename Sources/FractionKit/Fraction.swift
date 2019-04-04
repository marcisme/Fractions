import Foundation

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

  // TODO: can we use UInt?
  let whole: Int
  let numerator: Int
  let denominator: Int
  let isNegative: Bool

  public init(whole: Int, numerator: Int, denominator: Int, isNegative: Bool = false) {
    self.whole = whole
    self.numerator = numerator
    self.denominator = denominator
    self.isNegative = isNegative
  }

  public init(string: String) throws {
    guard string.count > 0 else {
      throw Error.emptyString
    }

    let parts = string.split(whereSeparator: { ["_", "/"].contains($0) })

    switch parts.count {
    case 1:
      // w
      let wholeParts = divineNegativity(parts[0])
      self.isNegative = wholeParts.0
      self.whole = try parseInt(wholeParts.1, type: .whole)
      self.numerator = 0
      self.denominator = 0
    case 2:
      // n/d
      let numeratorParts = divineNegativity(parts[0])
      self.isNegative = numeratorParts.0
      self.whole = 0
      self.numerator = try parseInt(numeratorParts.1, type: .numerator)
      self.denominator = try parseInt(String(parts[1]), type: .denominator)
    case 3:
      // w_n/d
      let wholeParts = divineNegativity(parts[0])
      self.isNegative = wholeParts.0
      self.whole = try parseInt(wholeParts.1, type: .whole)
      self.numerator = try parseInt(String(parts[1]), type: .numerator)
      self.denominator = try parseInt(String(parts[2]), type: .denominator)
    default:
      fatalError("expected 1, 2 or 3 parts")
    }
  }

  public var uiDescription: String {
    var d = ""
    if isNegative {
      d += "-"
    }
    if whole > 0 {
      d += String(whole)
    }
    if numerator > 0 {
      if whole > 0 {
        d += "_"
      }
      d += "\(numerator)/\(denominator)"
    }
    if whole == 0 && numerator == 0 {
      d += String(0)
    }
    return d
  }

  public var simplify: Fraction {
    if numerator == denominator {
      return Fraction(whole: whole + 1, numerator: 0, denominator: 0, isNegative: isNegative)
    }
    if denominator % numerator == 0 {
      return Fraction(whole: whole, numerator: 1, denominator: denominator / numerator, isNegative: isNegative)
    }
    if numerator > denominator {
      let wholeAddend = numerator / denominator
      let newNumerator = numerator % denominator
      return Fraction(whole: whole + wholeAddend, numerator: newNumerator, denominator: denominator, isNegative: isNegative)
    }
    return self
  }

  // TODO: LCD would reduce overflows
  public func commonify(_ other: Fraction) throws -> (Fraction, Fraction) {
    guard denominator != other.denominator else {
      return (self, other)
    }

    let commonDenominator = denominator * other.denominator
    let commonSelf = Fraction(whole: whole, numerator: numerator * other.denominator, denominator: commonDenominator)
    let commonOther = Fraction(whole: other.whole, numerator: other.numerator * denominator, denominator: commonDenominator)
    return (commonSelf, commonOther)
  }
}

// this is slightly less awkward than using a class method
fileprivate func divineNegativity(_ string: Substring) -> (Bool, String) {
  if string.starts(with: "-") {
    return (true, String(string.dropFirst()))
  } else {
    return (false, String(string))
  }
}

fileprivate func parseInt(_ string: String, type: Fraction.NumericComponentType) throws -> Int {
  if let int = Int(string) {
    return int
  }

  if string.isNumeric {
    throw Fraction.Error.outOfBounds(type)
  } else {
    throw Fraction.Error.invalid(type)
  }
}
