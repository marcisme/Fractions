public enum InfixOperation: Equatable {
  public enum Error: Swift.Error {
    case emptyString
    case invalidOperator
    case operationOverflowed
  }

  case addition(Fraction, Fraction)
  case subtraction(Fraction, Fraction)
  case multiplication(Fraction, Fraction)
  case division(Fraction, Fraction)

  public static func operation(for string: String, left: Fraction, right: Fraction) throws -> InfixOperation {
    guard string.count > 0 else {
      throw Error.emptyString
    }

    switch string {
    case "+":
      return .addition(left, right)
    default:
      throw Error.invalidOperator
    }
  }

  public func execute() throws -> Fraction {
    switch self {
    case let .addition(left, right):
      return try add(left, right)
    default:
      fatalError()
    }
  }

  private func add(_ left: Fraction, _ right: Fraction) throws -> Fraction {
    let (commonLeft, commonRight) = try left.commonify(right)
    switch (left.isNegative, right.isNegative) {
    case (false, false), (true, true):
      let whole = try addHandlingOverflow(commonLeft.whole, commonRight.whole)
      let numerator = try addHandlingOverflow(commonLeft.numerator, commonRight.numerator)
      let denominator = commonLeft.denominator
      let isNegative = left.isNegative && right.isNegative
      return Fraction(whole: whole, numerator: numerator, denominator: denominator, isNegative: isNegative)
    case (false, true):
      let whole = commonLeft.whole - commonRight.whole
      let numerator = commonLeft.numerator - commonRight.numerator
      let denominator = commonLeft.denominator
      let isNegative = whole < 0 || numerator < 0
      return Fraction(whole: abs(whole), numerator: abs(numerator), denominator: denominator, isNegative: isNegative)
    case (true, false):
      let whole = commonRight.whole - commonLeft.whole
      let numerator = commonRight.numerator - commonLeft.numerator
      let denominator = commonLeft.denominator
      let isNegative = whole < 0 || numerator < 0
      return Fraction(whole: abs(whole), numerator: abs(numerator), denominator: denominator, isNegative: isNegative)
    }
  }

  private func addHandlingOverflow(_ a: Int, _ b: Int) throws -> Int {
    let (result, overflow) = a.addingReportingOverflow(b)
    guard !overflow else {
      throw Error.operationOverflowed
    }
    return result
  }
}
