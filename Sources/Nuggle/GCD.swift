//
// Adapted from https://github.com/kodecocodes/swift-algorithm-club/blob/master/GCD/README.markdown
//

import Foundation

func greatestCommonDenominator(_ m: Int, _ n: Int) -> Int {
    return gcdBinaryRecursiveStein(abs(m), abs(n))
}

private func gcdBinaryRecursiveStein(_ m: Int, _ n: Int) -> Int {
    if let easySolution = findEasySolution(m, n) { return easySolution }

    if (m & 1) == 0 {
        // m is even
        if (n & 1) == 1 {
            // and n is odd
            return gcdBinaryRecursiveStein(m >> 1, n)
        } else {
            // both m and n are even
            return gcdBinaryRecursiveStein(m >> 1, n >> 1) << 1
        }
    } else if (n & 1) == 0 {
        // m is odd, n is even
        return gcdBinaryRecursiveStein(m, n >> 1)
    } else if (m > n) {
        // reduce larger argument
        return gcdBinaryRecursiveStein((m - n) >> 1, n)
    } else {
        // reduce larger argument
        return gcdBinaryRecursiveStein((n - m) >> 1, m)
    }
}

private func findEasySolution(_ m: Int, _ n: Int) -> Int? {
    if m == n { return m }
    if m == 0 { return n }
    if n == 0 { return m }
    return nil
}
