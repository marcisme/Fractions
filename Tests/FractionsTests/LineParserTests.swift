import XCTest
import FractionKit

final class LineParserTests: XCTestCase {
  func testEmptyInput() {
    let parser = LineParser()

    XCTAssertThrowsError(try parser.parse("")) { error in
      XCTAssertEqual(error as? LineParser.Error, LineParser.Error.emptyLine)
    }
  }

  func testInvalidInput() {
    let parser = LineParser()

    XCTAssertThrowsError(try parser.parse("a +")) { error in
      XCTAssertEqual(error as? LineParser.Error, LineParser.Error.invalidInput)
    }
    XCTAssertThrowsError(try parser.parse("a + b +")) { error in
      XCTAssertEqual(error as? LineParser.Error, LineParser.Error.invalidInput)
    }
  }

  func testValidInput() {
    let parser = LineParser()

    XCTAssertNoThrow(try parser.parse("1 + 1"))
    XCTAssertNoThrow(try parser.parse("  1    + 1     "))
  }

  func testInvalidOperator() {
    let parser = LineParser()

    XCTAssertThrowsError(try parser.parse("1 ? 1")) { error in
      XCTAssertEqual(error as? InfixOperation.Error, InfixOperation.Error.invalidOperator)
    }
  }

  // TODO: should this be wrapped in our own error?
  func testInvalidOperand() {
    let parser = LineParser()

    XCTAssertThrowsError(try parser.parse("a + 1")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.invalid(.whole))
    }
    XCTAssertThrowsError(try parser.parse("1 + a")) { error in
      XCTAssertEqual(error as? Fraction.Error, Fraction.Error.invalid(.whole))
    }
  }

  static var allTests = [
    ("testEmptyInput", testEmptyInput),
    ("testValidInput", testValidInput),
  ]
}
