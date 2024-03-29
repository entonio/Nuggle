//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

struct SplitDecimal: Codable {
    private let integerPart: Int
    private let decimalPart: Double

    private init(integerPart: Int, decimalPart: Double) {
        self.integerPart = integerPart
        self.decimalPart = decimalPart
    }
}

extension SplitDecimal: ExpressibleByIntegerLiteral {

    static let zero = Self(integerLiteral: 0)
    static let one = Self(integerLiteral: 1)

    public init(integerLiteral: Int) {
        self.init(
            integerPart: integerLiteral,
            decimalPart: 0
        )
    }
}

extension SplitDecimal: ExpressibleByFloatLiteral {
    public init(floatLiteral: Double) {
        if floatLiteral == 0 {
            self = .zero
        } else if floatLiteral == 1 {
            self = .one
        } else {
            let m = modf(floatLiteral)
            self.init(
                integerPart: Int(m.0),
                decimalPart: m.1
            )
        }
    }
}

extension SplitDecimal: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.double() == rhs.double()
    }
}

extension SplitDecimal: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(double())
    }
}

extension SplitDecimal {
    var isExactInt: Bool {
        decimalPart == 0
    }

    func exactInt() -> Int? {
        if isExactInt {
            return integerPart
        }
        return nil
    }

    func int() -> Int {
        if decimalPart == 0 {
            return integerPart
        }
        return Int(double().rounded())
    }

    func double() -> Double {
        Double(integerPart) + decimalPart
    }
}

extension SplitDecimal {
    func numberOfDecimals() -> Int {
        decimalPart == 0 ? 0 : String(abs(decimalPart)).dropFirst(2).count
    }
}

extension SplitDecimal: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        if rhs.integerPart < lhs.integerPart {
            return true
        }
        if rhs.integerPart > lhs.integerPart {
            return false
        }
        return lhs.decimalPart < rhs.decimalPart
    }
}

extension SplitDecimal {
    prefix static func - (operand: Self) -> Self {
        .init(
            integerPart: -operand.integerPart,
            decimalPart: -operand.decimalPart
        )
    }
}

extension SplitDecimal {
    static func + (lhs: Self, rhs: Self) -> Self {
        let c = SplitDecimal(floatLiteral: lhs.decimalPart + rhs.decimalPart)
        return .init(
            integerPart: lhs.integerPart + rhs.integerPart + c.integerPart,
            decimalPart: c.decimalPart
        )
    }

    static func * (lhs: Self, rhs: Int) -> Self {
        if rhs == 0 { return .zero }
        if rhs == 1 { return lhs }
        let c = SplitDecimal(floatLiteral: lhs.decimalPart * Double(rhs))
        return .init(
            integerPart: lhs.integerPart * rhs + c.integerPart,
            decimalPart: c.decimalPart
        )
    }

    static func * (lhs: Self, rhs: Self) -> Self {
        let c = SplitDecimal(floatLiteral: Double(lhs.integerPart) * rhs.decimalPart + lhs.decimalPart * Double(rhs.integerPart) + lhs.decimalPart * rhs.decimalPart)
        return .init(
            integerPart: lhs.integerPart * rhs.integerPart + c.integerPart,
            decimalPart: c.decimalPart
        )
    }

    static func / (lhs: Self, rhs: Int) -> Self {
        if rhs == 1 { return lhs }
        return lhs * SplitDecimal(floatLiteral: 1 / Double(rhs))
    }

    static func / (lhs: Self, rhs: Self) -> Self {
        lhs * SplitDecimal(floatLiteral: 1 / rhs.double())
    }
}

extension SplitDecimal: CustomStringConvertible {
    public var description: String {
        if let num = exactInt() {
            return num.description
        } else {
            return double().description
        }
    }
}

extension SplitDecimal: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}
