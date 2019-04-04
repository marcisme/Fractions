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
}
