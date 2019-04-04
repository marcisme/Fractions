import XCTest
import FractionKit

final class OperationTests: XCTestCase {
  func testEmptyString() {
    let f = Fraction(whole: 1, numerator: 1, denominator: 1)
    XCTAssertThrowsError(try InfixOperation.operation(for: "", left: f, right: f)) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.emptyString)
    }
  }

  func testInvalidOperator() {
    let f = Fraction(whole: 1, numerator: 1, denominator: 1)
    XCTAssertThrowsError(try InfixOperation.operation(for: "?", left: f, right: f)) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.invalidOperator)
    }
  }

  func testAdditionOperator() throws {
    let f = Fraction(whole: 1, numerator: 1, denominator: 1)

    let operation = try InfixOperation.operation(for: "+", left: f, right: f)

    XCTAssertEqual(operation, InfixOperation.addition(f, f))
  }

  static var allTests = [
    ("testEmptyString", testEmptyString),
  ]
}
