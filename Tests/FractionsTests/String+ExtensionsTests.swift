import XCTest
@testable import FractionKit

final class StringExtensionsTests: XCTestCase {
  func testEmptyString() {
    XCTAssertFalse("".isNumeric, "expected \"\" to be false")
  }

  func testNumericString() {
    XCTAssert("123".isNumeric, "expected \"123\" to be false")
  }

  func testAlphanumericString() {
    XCTAssertFalse("abc123".isNumeric, "expected \"abc123\" to be false")
  }

  func testAlphaString() {
    XCTAssertFalse("abc".isNumeric, "expected \"abc\" to be false")
  }

  static var allTests = [
    ("testEmptyString", testEmptyString),
  ]
}
