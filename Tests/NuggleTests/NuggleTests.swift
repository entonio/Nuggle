import XCTest
@testable import Nuggle

final class NuggleTests: XCTestCase {

    func test_init_int() throws {
        for _ in 0..<1_000_000 {
            let d = Double(Int.randomWithinIntRange())
            let i = Int(d)
            let s = Nuggle(floatLiteral: d)
            XCTAssertEqual(s.exactInt(), i)
        }
    }

    func test_init_double() throws {
        for _ in 0..<1_000_000 {
            let d = Double.randomWithinIntRange()
            let s = Nuggle(floatLiteral: d)
            XCTAssertEqual(s.exactInt(), Int(exactly: d))
            XCTAssertEqual(s.double(), d)
        }
    }

    func test_expression() throws {
        
        let m: Nuggle = 2.5
        let n: Nuggle = 1.5
        let p: Nuggle = 1

        let ex: Nuggle = 2.5 + 1.5 + 1

        XCTAssertEqual(m + n + p, ex)

        XCTAssertEqual(m + n, 4)
        XCTAssertEqual(m + n + p, 5)
        XCTAssertEqual(m + n + p, 4 + 1.6/4.8 + 2/3.0)

        XCTAssertEqual(m / n, 5 / 3)
        XCTAssertEqual((m / n).description, "5/3")

        XCTAssertEqual(ex.exactInt(), 5)

        XCTAssertEqual((m * 3).double(), 7.5)
    }
}
