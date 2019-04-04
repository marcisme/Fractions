import XCTest
import FractionKit

final class FractionTests: XCTestCase {
  func testEmptyString() {
    XCTAssertThrowsError(try Fraction(string: "")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.emptyString)
    }
  }

  func testValidWholeNumber() {
    guard let fraction = try? Fraction(string: "3") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 3, numerator: 0, denominator: 0))
  }

  func testOutOfBoundsWholeNumber() {
    XCTAssertThrowsError(try Fraction(string: "9223372036854775808")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.outOfBounds(.whole))
    }
  }

  // TODO: test negative number

  func testInvalidWholeNumber() {
    XCTAssertThrowsError(try Fraction(string: "w")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.invalid(.whole))
    }
  }

  func testValidFraction() {
    guard let fraction = try? Fraction(string: "1/2") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 0, numerator: 1, denominator: 2))
  }

  func testInvalidNumerator() {
    XCTAssertThrowsError(try Fraction(string: "n/2")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.invalid(.numerator))
    }
  }

  func testOutOfBoundsNumerator() {
    XCTAssertThrowsError(try Fraction(string: "9223372036854775808/1")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.outOfBounds(.numerator))
    }
  }

  func testInvalidDenominator() {
    XCTAssertThrowsError(try Fraction(string: "1/d")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.invalid(.denominator))
    }
  }

  func testOutOfBoundsDenominator() {
    XCTAssertThrowsError(try Fraction(string: "1/9223372036854775808")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.outOfBounds(.denominator))
    }
  }

  func testValidMixedNumber() {
    guard let fraction = try? Fraction(string: "1_2/3") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 1, numerator: 2, denominator: 3))
  }

  func testValidImproperFraction() {
    guard let fraction = try? Fraction(string: "2/1") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 0, numerator: 2, denominator: 1))
  }

  static var allTests = [
    ("testEmptyString", testEmptyString),
  ]
}
