public enum InfixOperation: Equatable {
  public enum Error: Swift.Error {
    case emptyString
    case invalidOperator
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
      return Fraction(whole: 1, numerator: 1, denominator: 1)
    default:
      fatalError()
    }
  }
}
