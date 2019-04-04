public struct LineParser {
  public enum Error: Swift.Error {
    case emptyLine
  }

  public init() {
  }

  public func parse(_ input: String) throws -> Operation {
    guard input.count > 0 else {
      throw Error.emptyLine
    }
    // FIXME
    struct StubOperation: Operation {
      func execute() -> Fraction {
        return Fraction(whole: 1, numerator: 1, denominator: 1)
      }
    }
    return StubOperation()
  }
}
