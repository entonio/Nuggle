//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

precedencegroup ExponentiationPrecedence {
    higherThan: MultiplicationPrecedence
    lowerThan: BitwiseShiftPrecedence
    associativity: right
    assignment: false
}
