public enum InfixOperation: Equatable {
  public enum Error: Swift.Error {
    case emptyString
    case invalidOperator
    case operationOverflowed
    case divisionByZero
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
    case "-":
      return .subtraction(left, right)
    case "*":
      return .multiplication(left, right)
    case "/":
      return .division(left, right)
    default:
      throw Error.invalidOperator
    }
  }

  public func execute() throws -> Fraction {
    switch self {
    case let .addition(left, right):
      return try add(left, right)
    case let .subtraction(left, right):
      return try subtract(left, right)
    case let .multiplication(left, right):
      return try multiply(left, right)
    case let .division(left, right):
      return try divide(left, right)
    }
  }

  private func add(_ left: Fraction, _ right: Fraction) throws -> Fraction {
    let (commonLeft, commonRight) = try left.commonify(right)
    let numerator = try addHandlingOverflow(commonLeft.numerator, commonRight.numerator)
    return Fraction(numerator: numerator, denominator: commonLeft.denominator)
  }

  private func addHandlingOverflow(_ a: Int, _ b: Int) throws -> Int {
    let (result, overflow) = a.addingReportingOverflow(b)
    guard !overflow else {
      throw Error.operationOverflowed
    }
    return result
  }

  private func subtract(_ left: Fraction, _ right: Fraction) throws -> Fraction {
    let (commonLeft, commonRight) = try left.commonify(right)
    let numerator = try subtractHandlingOverflow(commonLeft.numerator, commonRight.numerator)
    return Fraction(numerator: numerator, denominator: commonLeft.denominator)
  }

  private func subtractHandlingOverflow(_ a: Int, _ b: Int) throws -> Int {
    let (result, overflow) = a.subtractingReportingOverflow(b)
    guard !overflow else {
      throw Error.operationOverflowed
    }
    return result
  }

  private func multiply(_ left: Fraction, _ right: Fraction) throws -> Fraction {
    let numerator = try multiplyHandlingOverflow(left.numerator, right.numerator)
    let denominator = try multiplyHandlingOverflow(left.denominator, right.denominator)
    return Fraction(numerator: numerator, denominator: denominator)
  }

  private func multiplyHandlingOverflow(_ a: Int, _ b: Int) throws -> Int {
    let (result, overflow) = a.multipliedReportingOverflow(by: b)
    guard !overflow else {
      throw Error.operationOverflowed
    }
    return result
  }

  private func divide(_ left: Fraction, _ right: Fraction) throws -> Fraction {
    guard right.numerator > 0 else {
      throw Error.divisionByZero
    }

    let recipricol = Fraction(numerator: right.denominator, denominator: right.numerator)
    return try multiply(left, recipricol)
  }
}
