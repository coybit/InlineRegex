import XCTest
@testable import InlineRegex

final class InlineRegexTests: XCTestCase {
    func testExample() {
        struct Info {
            var action: String? = nil
            var phone: String? = nil
        }
        
        var info = Info()
        
        InlineRegex.on("Call    me:  +123456",
                       pattern: "^\("\\w+", \.action)\\s+\\w+:\\s+\\+\("\\d{6}", \.phone)",
                       store: &info)
        
        XCTAssertEqual(info.action, "Call")
        XCTAssertEqual(info.phone, "123456")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
