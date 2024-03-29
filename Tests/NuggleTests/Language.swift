//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension Int {
    static func randomWithinIntRange() -> Int {
        Int.random(
            in: Int.min...Int.max
        )
    }
}

extension Double {
    static func randomWithinIntRange() -> Double {
        Double.random(
            in: Double(Int.min)...Double(Int.max)
        )
    }

    // https://stackoverflow.com/q/75467199
    static func random() -> Double {
        let range = 0...Double.greatestFiniteMagnitude
        let signs: [Double] = [-1, 1]
        return Double.random(in: range) * signs.randomElement()!
    }
}

