import XCTest
import FractionKit

final class LineParserTests: XCTestCase {
  func testEmptyInput() {
    let parser = LineParser()

    XCTAssertThrowsError(try parser.parse("")) { error in
      XCTAssertEqual(error as? LineParser.Error, LineParser.Error.emptyLine)
    }
  }

  func testValidInput() {
    let parser = LineParser()

    XCTAssertNoThrow(try parser.parse("1 + 1"))
    XCTAssertNoThrow(try parser.parse(" 1 + 1 "))
  }

  static var allTests = [
    ("testEmptyInput", testEmptyInput),
    ("testValidInput", testValidInput),
  ]
}
