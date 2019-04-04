import Foundation

fileprivate let regex = try! NSRegularExpression(pattern: "^\\d+$")

extension String {
  var isNumeric: Bool {
    return regex.numberOfMatches(in: self, range: NSMakeRange(0, self.count)) > 0
  }
}
