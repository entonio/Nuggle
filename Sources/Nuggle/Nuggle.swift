//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

public struct Nuggle: Codable {
    private let num: SplitDecimal
    private let den: Int

    private init(_ num: SplitDecimal, _ den: Int) {
        if den < 0 {
            self.num = -num
            self.den = -den
        } else {
            self.num = num
            self.den = den
        }
    }
}

extension Nuggle {
    init(_ num: SplitDecimal) {
        self.init(num, 1)
    }
}

extension Nuggle {
    public init(_ num: any Numeric) {
        self.init(num, 1)
    }

    init(_ num: any Numeric, _ den: Int) {
        if let num = num as? Int {
            self.init(SplitDecimal(integerLiteral: num), den)
        } else {
            self.init(SplitDecimal(floatLiteral: Double(num)), 1)
        }
    }
}

extension Nuggle: ExpressibleByIntegerLiteral {
    public init(integerLiteral: Int) {
        self.init(SplitDecimal(integerLiteral: integerLiteral), 1)
    }
}

extension Nuggle: ExpressibleByFloatLiteral {
    public init(floatLiteral: Double) {
        self = .init(SplitDecimal(floatLiteral: floatLiteral), 1).rational.simplified
    }
}

extension Nuggle {
    public init?(_ string: String) {
        var string = string
        if string.contains(",") {
            string = string.replacingOccurrences(of: ",", with: ".")
        }
        if string.contains(".") {
            guard let d = Double(string) else {
                return nil
            }
            self.init(floatLiteral: d)
        } else {
            guard let i = Int(string) else {
                return nil
            }
            self.init(integerLiteral: i)
        }
    }
}

extension Nuggle: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.num == rhs.num, lhs.den == rhs.den {
            return true
        }
        let lhs = lhs.simplified
        let rhs = rhs.simplified
        if lhs.num == rhs.num, lhs.den == rhs.den {
            return true
        }
        return false
    }
}

extension Nuggle: Hashable {
    public func hash(into hasher: inout Hasher) {
        let s = self.simplified
        hasher.combine(s.num)
        hasher.combine(s.den)
    }
}

extension Nuggle {
    public func exactInt() -> Int? {
        if let num = num.exactInt() {
            let quotient = num / den
            if quotient * den == num {
                return quotient
            }
        }
        return nil
    }

    public func int() -> Int {
        Int(double())
    }

    public func double() -> Double {
        num.double() / Double(den)
    }
}

extension Nuggle {
    private var rational: Nuggle {
        let decimals = num.numberOfDecimals()
        if decimals == 0 {
            return self
        }
        let multiplier = 10 * decimals
        return Nuggle(
            Int(num.double() * Double(multiplier)),
            den * multiplier
        )
    }

    public var simplified: Nuggle {
        guard let num = num.exactInt() else {
            return rational.simplified
        }

        if num == 0 && den != 0 { return 0 }

        if den == 1 { return self }

        let gcd = greatestCommonDenominator(num, den)
        if den == gcd { return Nuggle(num / den) }

        return Nuggle(num / gcd, den / gcd)
    }
}

public func abs(_ nuggle: Nuggle) -> Nuggle {
    nuggle < 0 ? -nuggle : nuggle
}

extension Nuggle: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.double() < rhs.double()
    }
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.double() <= rhs.double()
    }
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.double() > rhs.double()
    }
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.double() >= rhs.double()
    }
}

extension Nuggle {
    public prefix static func - (operand: Self) -> Self {
        .init(-operand.num, operand.den)
    }
}

prefix operator √ 

extension Nuggle {
    public prefix static func √ (operand: Self) -> Self {
        2 √ operand
    }
}

infix operator ↗ : ExponentiationPrecedence
infix operator √ : ExponentiationPrecedence

extension Nuggle {
    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs + (-rhs)
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        if lhs.den == rhs.den {
            return .init(
                lhs.num + rhs.num,
                lhs.den
            )
        }
        return .init(
            lhs.num * SplitDecimal(integerLiteral: rhs.den) + rhs.num * SplitDecimal(integerLiteral: lhs.den),
            lhs.den * rhs.den
        )
    }

    public static func * (lhs: Self, rhs: Self) -> Self {
        return .init(
            lhs.num * rhs.num,
            lhs.den * rhs.den
        ).simplified
    }

    public static func / (lhs: Self, rhs: Self) -> Self {
        if let rhsn = rhs.num.exactInt() {
            return .init(
                lhs.num * SplitDecimal(integerLiteral: rhs.den),
                lhs.den * rhsn
            ).simplified
        }
        return .init(
            lhs.num * SplitDecimal(integerLiteral: rhs.den) / rhs.num,
            lhs.den
        ).simplified
    }

    public static func √ (lhs: Self, rhs: Self) -> Self {
        rhs ↗ (1 / lhs)
    }

    public static func ↗ (lhs: Self, rhs: Self) -> Self {
        if let exp = rhs.exactInt() {
            if exp == 0 {
                return 1
            }
            if let baseNum = lhs.num.exactInt() {
                if exp > 0 {
                    return .init(
                        pow(baseNum, exp),
                        pow(lhs.den, exp)
                    ).simplified
                } else {
                    return .init(
                        pow(lhs.den, -exp),
                        pow(baseNum, -exp)
                    ).simplified
                }
            }
        }
        return .init(floatLiteral: pow(lhs.double(), rhs.double()))
    }
}

infix operator ** : ExponentiationPrecedence

extension Nuggle {
    public static func ** (lhs: Self, rhs: Self) -> Self {
        lhs ↗ rhs
    }
}

extension Nuggle: CustomStringConvertible {
    public var description: String {
        if den == 1 {
            return num.description
        }
        return num.description + "/" + den.description
    }
}

extension Nuggle: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}
