import XCTest
@testable import HealthPublishers

final class HealthPublishersTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(HealthPublishers().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
