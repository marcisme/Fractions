import XCTest
import FractionKit

final class OperationTests: XCTestCase {
  func testEmptyString() {
    let f = Fraction(numerator: 1, denominator: 1)
    XCTAssertThrowsError(try InfixOperation.operation(for: "", left: f, right: f)) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.emptyString)
    }
  }

  func testInvalidOperator() {
    let f = Fraction(numerator: 1, denominator: 1)
    XCTAssertThrowsError(try InfixOperation.operation(for: "?", left: f, right: f)) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.invalidOperator("?"))
    }
  }

  func testAdditionOperator() throws {
    let f = Fraction(numerator: 1, denominator: 1)

    let operation = try InfixOperation.operation(for: "+", left: f, right: f)

    XCTAssertEqual(operation, InfixOperation.addition(f, f))
  }

  func testSubtractionOperator() throws {
    let f = Fraction(numerator: 1, denominator: 1)

    let operation = try InfixOperation.operation(for: "-", left: f, right: f)

    XCTAssertEqual(operation, InfixOperation.subtraction(f, f))
  }

  func testMultiplicationOperator() throws {
    let f = Fraction(numerator: 1, denominator: 1)

    let operation = try InfixOperation.operation(for: "*", left: f, right: f)

    XCTAssertEqual(operation, InfixOperation.multiplication(f, f))
  }

  func testDivisionOperator() throws {
    let f = Fraction(numerator: 1, denominator: 1)

    let operation = try InfixOperation.operation(for: "/", left: f, right: f)

    XCTAssertEqual(operation, InfixOperation.division(f, f))
  }

  // MARK: Addition

  func testPositiveAddition() throws {
    let left = Fraction(numerator: 1, denominator: 1)
    let right = Fraction(numerator: 1, denominator: 2)
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(numerator: 3, denominator: 2))
  }

  func testNegativeAdditionWithPositiveResult() throws {
    let left = Fraction(numerator: 1, denominator: 1)
    let right = Fraction(numerator: -1, denominator: 2)
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(numerator: 1, denominator: 2))
  }

  func testNegativeAdditionWithNegativeResult() throws {
    let left = Fraction(numerator: -1, denominator: 1)
    let right = Fraction(numerator: -1, denominator: 2)
    let operation = InfixOperation.addition(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(numerator: -3, denominator: 2))
  }

  func testAdditionNumeratorOverflow() throws {
    let left = Fraction(numerator: Int.max, denominator: 1)
    let right = Fraction(numerator: 1, denominator: 1)
    let operation = InfixOperation.addition(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  // MARK: Subtraction

  func testPositiveSubtraction() throws {
    let left = Fraction(numerator: 2, denominator: 1)
    let right = Fraction(numerator: 1, denominator: 2)
    let operation = InfixOperation.subtraction(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(numerator: 3, denominator: 2))
  }

  func testNegativeSubtraction() throws {
    let left = Fraction(numerator: 2, denominator: 1)
    let right = Fraction(numerator: -1, denominator: 2)
    let operation = InfixOperation.subtraction(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(numerator: 5, denominator: 2))
  }

  func testSubtractionOverflow() throws {
    let left = Fraction(numerator: Int.max, denominator: 1)
    let right = Fraction(numerator: -1, denominator: 1)
    let operation = InfixOperation.subtraction(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  // MARK: Multiplication

  func testMultiplication() throws {
    let left = Fraction(numerator: 3, denominator: 1)
    let right = Fraction(numerator: 1, denominator: 2)
    let operation = InfixOperation.multiplication(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(numerator: 3, denominator: 2))
  }

  func testSubtractionNumeratorOverflow() throws {
    let left = Fraction(numerator: Int.max, denominator: 1)
    let right = Fraction(numerator: 2, denominator: 1)
    let operation = InfixOperation.multiplication(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  func testSubtractionDenominatorOverflow() throws {
    let left = Fraction(numerator: 1, denominator: Int.max)
    let right = Fraction(numerator: 1, denominator: 2)
    let operation = InfixOperation.multiplication(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  // MARK: Division

  func testDivision() throws {
    let left = Fraction(numerator: 10, denominator: 1)
    let right = Fraction(numerator: 5, denominator: 2)
    let operation = InfixOperation.division(left, right)

    let result = try operation.execute()

    XCTAssertEqual(result, Fraction(numerator: 20, denominator: 5))
  }

  func testDivisionNumeratorOverflow() throws {
    let left = Fraction(numerator: Int.max, denominator: 1)
    let right = Fraction(numerator: 2, denominator: 2)
    let operation = InfixOperation.division(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  func testDivisionDenominatorOverflow() throws {
    let left = Fraction(numerator: 1, denominator: Int.max)
    let right = Fraction(numerator: 2, denominator: 2)
    let operation = InfixOperation.division(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.operationOverflowed)
    }
  }

  func testDivisionByZero() throws {
    let left = Fraction(numerator: 1, denominator: 1)
    let right = Fraction(numerator: 0, denominator: 1)
    let operation = InfixOperation.division(left, right)

    XCTAssertThrowsError(try operation.execute()) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.divisionByZero)
    }
  }

  static var allTests = [
    ("testEmptyString", testEmptyString),
  ]
}
