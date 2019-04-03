import XCTest
import class Foundation.Bundle

final class FractionsTests: XCTestCase {
    func testExample() throws {
        // // This is an example of a functional test case.
        // // Use XCTAssert and related functions to verify your tests produce the correct
        // // results.
        //
        // // Some of the APIs that we use below are available in macOS 10.13 and above.
        // guard #available(macOS 10.13, *) else {
        //     return
        // }
        //
        // let fooBinary = productsDirectory.appendingPathComponent("Fractions")
        //
        // let process = Process()
        // process.executableURL = fooBinary
        //
        // let pipe = Pipe()
        // process.standardOutput = pipe
        //
        // let opipe = Pipe()
        // process.standardInput = opipe
        //
        // try process.run()
        // // process.waitUntilExit()
        //
        // // opipe.fileHandleForWriting.write(Data([UInt8(4)]))
        // opipe.fileHandleForWriting.write("exit".data(using: .utf8)!)
        // opipe.fileHandleForWriting.synchronizeFile()
        //
        // // process.waitUntilExit()
        //
        // let data = pipe.fileHandleForReading.readDataToEndOfFile()
        // let output = String(data: data, encoding: .utf8)
        //
        // XCTAssertEqual(output, "? x")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
