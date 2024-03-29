//
// Copyright © 2024 Antonio Marques. All rights reserved.
//

import Foundation

extension Double {
    init(_ content: any Numeric) {
       if let content = content as? Int {
           self = .init(content)
       } else if let content = content as? Float {
           self = .init(content)
       } else {
           self = content as! Double
       }
   }
}

// https://stackoverflow.com/a/60131377
func pow(_ base: Int, _ exp: Int) -> Int {
    var result: Int = 1
    var base = base
    var exp = exp
    while true {
        if exp % 2 == 1 {
            result *= base
        }
        exp = exp >> 1
        if exp == 0 {
            break
        }
        base *= base
    }
    return result
}
