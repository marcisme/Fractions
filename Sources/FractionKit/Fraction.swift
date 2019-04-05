import Foundation

public struct Fraction: Equatable {
  public enum NumericComponentType: Equatable {
    case whole
    case numerator
    case denominator
  }

  public enum Error: Swift.Error, Equatable, LocalizedError {
    case emptyString
    case invalid(NumericComponentType)
    case outOfBounds(NumericComponentType)

    public var errorDescription: String? {
      switch self {
      case .invalid:
        return "Invalid number"
      case .outOfBounds:
        return "Value is out of bounds"
      default:
        return nil
      }
    }
  }

  private var whole: Int {
    guard denominator > 0 else { return 0 }
    return numerator / denominator
  }

  let numerator: Int
  let denominator: Int

  public init(numerator: Int, denominator: Int) {
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
      // w
      self.numerator = try parseInt(String(parts[0]), type: .whole)
      self.denominator = 1
    case 2:
      // n/d
      self.numerator = try parseInt(String(parts[0]), type: .numerator)
      self.denominator = try parseInt(String(parts[1]), type: .denominator)
    case 3:
      // w_n/d
      self.denominator = try parseInt(String(parts[2]), type: .denominator)
      let whole = try parseInt(String(parts[0]), type: .whole) * self.denominator
      let numerator = try parseInt(String(parts[1]), type: .numerator)
      if whole < 0 {
        self.numerator = whole - numerator
      } else {
        self.numerator = whole + numerator
      }
    default:
      fatalError("expected 1, 2 or 3 parts")
    }
  }

  public var uiDescription: String {
    var d = ""
    if whole != 0 {
      d += String(whole)
    }
    let numeratorLessWhole = numerator - (whole * denominator)
    if numeratorLessWhole != 0 {
      if whole != 0 {
        d += "_\(abs(numeratorLessWhole))/\(denominator)"
      } else {
        d += "\(numeratorLessWhole)/\(denominator)"
      }
    }
    if whole == 0 && numerator == 0 {
      d += String(0)
    }
    return d
  }

  public var simplify: Fraction {
    let gcd = computeGCD(numerator, denominator)
    return Fraction(numerator: numerator / gcd, denominator: denominator / gcd)
  }

  // Thank you, Ray
  // https://github.com/raywenderlich/swift-algorithm-club/tree/master/GCD
  private func computeGCD(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
      a = b
      b = r
      r = a % b
    }
    return b
  }

  public func commonify(_ other: Fraction) throws -> (Fraction, Fraction) {
    guard denominator != other.denominator else {
      return (self, other)
    }

    let lcm = computeLCM(denominator, other.denominator)
    let commonSelf = Fraction(numerator: numerator * (lcm / denominator), denominator: lcm)
    let commonOther = Fraction(numerator: other.numerator * (lcm / other.denominator), denominator: lcm)
    return (commonSelf, commonOther)
  }

  private func computeLCM(_ m: Int, _ n: Int) -> Int {
    return m / computeGCD(m, n) * n
  }
}

// this is slightly less awkward than using a class method
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
