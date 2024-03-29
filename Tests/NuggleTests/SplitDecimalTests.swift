import XCTest
@testable import Nuggle

final class SplitDecimalTests: XCTestCase {

    func test_init_int() throws {
        for _ in 0..<1_000_000 {
            let d = Double(Int.randomWithinIntRange())
            let i = Int(d)
            let s = SplitDecimal(floatLiteral: d)
            XCTAssertEqual(s.exactInt(), i)
        }
    }
    
    func test_init_double() throws {
        for _ in 0..<1_000_000 {
            let d = Double.randomWithinIntRange()
            let s = SplitDecimal(floatLiteral: d)
            XCTAssertEqual(s.exactInt(), Int(exactly: d))
            XCTAssertEqual(s.double(), d)
        }
    }

    func test_sum_int() throws {
        for _ in 0..<1_000 {
            let d = Double(Int.randomWithinIntRange())
            let i = Int(d)
            for _ in 0..<1_000 {
                let a = Int.random(in: -1_000_000_000...1_000_000_000)
                let s = SplitDecimal(floatLiteral: d) + SplitDecimal(integerLiteral: a)
                XCTAssertEqual(s.exactInt(), i + a)
            }
        }
    }

    func test_multiply_int() throws {
        for _ in 0..<1_000 {
            let d = Double(Int.randomWithinIntRange() / 1_000_000)
            let i = Int(d)
            for _ in 0..<1_000 {
                let a = Int.random(in: (-1_000_000 + 1)...(1_000_000 - 1))
                let s = SplitDecimal(floatLiteral: d) * SplitDecimal(integerLiteral: a)
                XCTAssertEqual(s.exactInt(), i * a)
            }
        }
    }

    func test_div() throws {
        for _ in 0..<1 {
            let d = Double.randomWithinIntRange()
            for _ in 0..<1_000 {
                let a = Double.randomWithinIntRange()
                let s = SplitDecimal(floatLiteral: d) / SplitDecimal(floatLiteral: a)
                XCTAssertLessThan(abs(s.double() - d / a), 0.00000000001)
            }
        }
    }

    func test_div_int_then_sum() throws {
        for _ in 0..<1_000 {
            let i = Int.random(in: -1_000_000_000...1_000_000_000)
            for div in 2...19 {
                let d = Double(i) / Double(div)
                let a = SplitDecimal(floatLiteral: d)
                var s = SplitDecimal(floatLiteral: 0)
                for _ in 1...div {
                    s = s + a
                }
                XCTAssertEqual(s.int(), i)
            }
        }
    }

    func test_div_int_then_multiply() throws {
        for _ in 0..<1_000 {
            let i = Int.random(in: -1_000_000_000...1_000_000_000)
            for div in 2...19 {
                let d = Double(i) / Double(div)
                let s = SplitDecimal(floatLiteral: d) * SplitDecimal(integerLiteral: div)
                XCTAssertEqual(s.int(), i)
            }
        }
    }
}
