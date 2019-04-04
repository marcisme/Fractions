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

    XCTAssertEqual(fraction, Fraction(numerator: 3, denominator: 1))
  }

  func testValidWholeNegativeNumber() {
    guard let fraction = try? Fraction(string: "-3") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(numerator: -3, denominator: 1))
  }

  func testInvalidWholeNumber() {
    XCTAssertThrowsError(try Fraction(string: "w")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.invalid(.whole))
    }
  }

  func testOutOfBoundsWholeNumber() {
    XCTAssertThrowsError(try Fraction(string: "9223372036854775808")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.outOfBounds(.whole))
    }
  }

  func testValidFraction() {
    guard let fraction = try? Fraction(string: "1/2") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(numerator: 1, denominator: 2))
  }

  func testValidNegativeFraction() {
    guard let fraction = try? Fraction(string: "-1/2") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(numerator: -1, denominator: 2))
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

    XCTAssertEqual(fraction, Fraction(numerator: 5, denominator: 3))
  }

  func testValidMixedNegativeNumber() {
    guard let fraction = try? Fraction(string: "-1_2/3") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(numerator: -5, denominator: 3))
  }

  func testValidImproperFraction() {
    guard let fraction = try? Fraction(string: "2/1") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(numerator: 2, denominator: 1))
  }

  // MARK: commonify

  func testCommonify() throws {
    let fraction = Fraction(numerator: 1, denominator: 3) // 2/6
    let other = Fraction(numerator: 1, denominator: 2) // 3/6

    let fractionResult = try fraction.commonify(other)
    let otherResult = try other.commonify(fraction)

    XCTAssertEqual(fractionResult.0, Fraction(numerator: 2, denominator: 6))
    XCTAssertEqual(fractionResult.1, Fraction(numerator: 3, denominator: 6))
    XCTAssertEqual(otherResult.0, Fraction(numerator: 3, denominator: 6))
    XCTAssertEqual(otherResult.1, Fraction(numerator: 2, denominator: 6))
  }

  func testCommonifyNoFraction() throws {
    let fraction = Fraction(numerator: 1, denominator: 1)
    let other = Fraction(numerator: 1, denominator: 2)

    let fractionResult = try fraction.commonify(other)
    let otherResult = try other.commonify(fraction)

    XCTAssertEqual(fractionResult.0, Fraction(numerator: 2, denominator: 2))
    XCTAssertEqual(fractionResult.1, Fraction(numerator: 1, denominator: 2))
    XCTAssertEqual(otherResult.0, Fraction(numerator: 1, denominator: 2))
    XCTAssertEqual(otherResult.1, Fraction(numerator: 2, denominator: 2))
  }

  func testCommonifyWhenAlreadyCommon() throws {
    let fraction = Fraction(numerator: 1, denominator: 2)
    let other = Fraction(numerator: 1, denominator: 2)

    let fractionResult = try fraction.commonify(other)
    let otherResult = try other.commonify(fraction)

    XCTAssertEqual(fractionResult.0, Fraction(numerator: 1, denominator: 2))
    XCTAssertEqual(fractionResult.1, Fraction(numerator: 1, denominator: 2))
    XCTAssertEqual(otherResult.0, Fraction(numerator: 1, denominator: 2))
    XCTAssertEqual(otherResult.1, Fraction(numerator: 1, denominator: 2))
  }

  // MARK: uiDescription

  func testUIDescriptionForPositiveWhole() {
    XCTAssertEqual(Fraction(numerator: 1, denominator: 1).uiDescription, "1")
  }

  func testUIDescriptionForPositiveFraction() {
    XCTAssertEqual(Fraction(numerator: 1, denominator: 2).uiDescription, "1/2")
  }

  func testUIDescriptionForPositiveCompound() {
    XCTAssertEqual(Fraction(numerator: 5, denominator: 3).uiDescription, "1_2/3")
  }

  func testUIDescriptionForNegativeWhole() {
    XCTAssertEqual(Fraction(numerator: -1, denominator: 1).uiDescription, "-1")
  }

  func testUIDescriptionForNegativeFraction() {
    XCTAssertEqual(Fraction(numerator: -1, denominator: 2).uiDescription, "-1/2")
  }

  func testUIDescriptionForNegativeCompound() {
    XCTAssertEqual(Fraction(numerator: -5, denominator: 3).uiDescription, "-1_2/3")
  }

  func testUIDescriptionForZero() {
    XCTAssertEqual(Fraction(numerator: 0, denominator: 0).uiDescription, "0")
  }

  // MARK: simplify

  func testSimplifyWhenSimplified() {
    let f = Fraction(numerator: 5, denominator: 3)
    XCTAssertEqual(f.simplify, Fraction(numerator: 5, denominator: 3))
  }

  func testSimplifyEqualNumeratorAndDenominator() {
    let f = Fraction(numerator: 1, denominator: 1)
    XCTAssertEqual(f.simplify, Fraction(numerator: 1, denominator: 1))
  }

  func testSimplifyDenominatorEvenlyDivisibleByNumerator() {
    let f = Fraction(numerator: 2, denominator: 4)
    XCTAssertEqual(f.simplify, Fraction(numerator: 1, denominator: 2))
  }

  func testSimplifyImproper() {
    let f = Fraction(numerator: 10, denominator: 4)
    XCTAssertEqual(f.simplify, Fraction(numerator: 5, denominator: 2))
  }

  static var allTests = [
    ("testEmptyString", testEmptyString),
  ]
}
