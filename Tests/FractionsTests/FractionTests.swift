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

  func testValidWholeNegativeNumber() {
    guard let fraction = try? Fraction(string: "-3") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 3, numerator: 0, denominator: 0, isNegative: true))
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

    XCTAssertEqual(fraction, Fraction(whole: 0, numerator: 1, denominator: 2))
  }

  func testValidNegativeFraction() {
    guard let fraction = try? Fraction(string: "-1/2") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 0, numerator: 1, denominator: 2, isNegative: true))
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

  func testValidMixedNegativeNumber() {
    guard let fraction = try? Fraction(string: "-1_2/3") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 1, numerator: 2, denominator: 3, isNegative: true))
  }

  func testValidImproperFraction() {
    guard let fraction = try? Fraction(string: "2/1") else {
      XCTFail("expected fraction")
      return
    }

    XCTAssertEqual(fraction, Fraction(whole: 0, numerator: 2, denominator: 1))
  }

  // MARK: commonify

  func testCommonify() throws {
    let fraction = Fraction(whole: 0, numerator: 1, denominator: 3) // 2/6
    let other = Fraction(whole: 0, numerator: 1, denominator: 2) // 3/6

    let fractionResult = try fraction.commonify(other)
    let otherResult = try other.commonify(fraction)

    XCTAssertEqual(fractionResult.0, Fraction(whole: 0, numerator: 2, denominator: 6))
    XCTAssertEqual(fractionResult.1, Fraction(whole: 0, numerator: 3, denominator: 6))
    XCTAssertEqual(otherResult.0, Fraction(whole: 0, numerator: 3, denominator: 6))
    XCTAssertEqual(otherResult.1, Fraction(whole: 0, numerator: 2, denominator: 6))
  }

  func testCommonifyWhenAlreadyCommon() throws {
    let fraction = Fraction(whole: 0, numerator: 1, denominator: 2)
    let other = Fraction(whole: 0, numerator: 1, denominator: 2)

    let fractionResult = try fraction.commonify(other)
    let otherResult = try other.commonify(fraction)

    XCTAssertEqual(fractionResult.0, Fraction(whole: 0, numerator: 1, denominator: 2))
    XCTAssertEqual(fractionResult.1, Fraction(whole: 0, numerator: 1, denominator: 2))
    XCTAssertEqual(otherResult.0, Fraction(whole: 0, numerator: 1, denominator: 2))
    XCTAssertEqual(otherResult.1, Fraction(whole: 0, numerator: 1, denominator: 2))
  }

  // MARK: uiDescription

  func testUIDescriptionForPositiveWhole() {
    XCTAssertEqual(Fraction(whole: 1, numerator: 0, denominator: 0).uiDescription, "1")
  }

  func testUIDescriptionForPositiveFraction() {
    XCTAssertEqual(Fraction(whole: 0, numerator: 1, denominator: 2).uiDescription, "1/2")
  }

  func testUIDescriptionForPositiveCompound() {
    XCTAssertEqual(Fraction(whole: 1, numerator: 2, denominator: 3).uiDescription, "1_2/3")
  }

  func testUIDescriptionForNegativeWhole() {
    XCTAssertEqual(Fraction(whole: 1, numerator: 0, denominator: 0, isNegative: true).uiDescription, "-1")
  }

  func testUIDescriptionForNegativeFraction() {
    XCTAssertEqual(Fraction(whole: 0, numerator: 1, denominator: 2, isNegative: true).uiDescription, "-1/2")
  }

  func testUIDescriptionForNegativeCompound() {
    XCTAssertEqual(Fraction(whole: 1, numerator: 2, denominator: 3, isNegative: true).uiDescription, "-1_2/3")
  }

  func testUIDescriptionForZero() {
    XCTAssertEqual(Fraction(whole: 0, numerator: 0, denominator: 0).uiDescription, "0")
  }

  static var allTests = [
    ("testEmptyString", testEmptyString),
  ]
}
