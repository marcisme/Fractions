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

  // MARK: Addition

  func testPositivePositiveAddition() throws {
    let left = Fraction(whole: 0, numerator: 1, denominator: 2)
    let right = Fraction(whole: 0, numerator: 1, denominator: 3)
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 0, numerator: 5, denominator: 6))
  }

  func testNegativeNegativeAddition() throws {
    let left = Fraction(whole: 0, numerator: 1, denominator: 2, isNegative: true)
    let right = Fraction(whole: 0, numerator: 1, denominator: 3, isNegative: true)
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 0, numerator: 5, denominator: 6, isNegative: true))
  }

  func testPositiveNegativeAdditionWithPositiveResult() throws {
    let left = Fraction(whole: 2, numerator: 1, denominator: 2) // 2_3/6
    let right = Fraction(whole: 1, numerator: 1, denominator: 3, isNegative: true) // 1_2/6
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 1, numerator: 1, denominator: 6))
  }

  func testPositiveNegativeAdditionWithNegativeWholeResult() throws {
    let left = Fraction(whole: 1, numerator: 1, denominator: 2) // 1_3/6
    let right = Fraction(whole: 2, numerator: 1, denominator: 3, isNegative: true) // 2_2/6
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 1, numerator: 1, denominator: 6, isNegative: true))
  }

  func testPositiveNegativeAdditionWithNegativeFractionResult() throws {
    let left = Fraction(whole: 2, numerator: 1, denominator: 3) // 2_2/6
    let right = Fraction(whole: 2, numerator: 1, denominator: 2, isNegative: true) // 2_3/6
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 0, numerator: 1, denominator: 6, isNegative: true))
  }

  func testNegativePositiveAdditionWithPositiveResult() throws {
    let left = Fraction(whole: 1, numerator: 1, denominator: 3, isNegative: true) // 1_2/6
    let right = Fraction(whole: 2, numerator: 1, denominator: 2) // 2_3/6
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 1, numerator: 1, denominator: 6))
  }

  func testNegativePositiveAdditionWithNegativeWholeResult() throws {
    let left = Fraction(whole: 2, numerator: 1, denominator: 3, isNegative: true) // 2_2/6
    let right = Fraction(whole: 1, numerator: 1, denominator: 2) // 1_3/6
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 1, numerator: 1, denominator: 6, isNegative: true))
  }

  func testNegativePositiveAdditionWithNegativeFractionResult() throws {
    let left = Fraction(whole: 2, numerator: 1, denominator: 2, isNegative: true) // 2_3/6
    let right = Fraction(whole: 2, numerator: 1, denominator: 3) // 2_2/6
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(whole: 0, numerator: 1, denominator: 6, isNegative: true))
  }

  func testAdditionWholeOverflow() throws {
    let left = Fraction(whole: Int.max, numerator: 1, denominator: 1)
    let right = Fraction(whole: 1, numerator: 1, denominator: 1)
    let operation = InfixOperation.addition(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  func testAdditionNumeratorOverflow() throws {
    let left = Fraction(whole: 0, numerator: Int.max, denominator: 1)
    let right = Fraction(whole: 0, numerator: 1, denominator: 1)
    let operation = InfixOperation.addition(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  static var allTests = [
    ("testEmptyString", testEmptyString),
  ]
}
