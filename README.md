# Nuggle

Common compiled languages keep a visible separation between integer and floating point numbers. The purpose of this package is to allow performing mathematical operations without having to do type conversions:

- where possible / reasonable, floating point numbers are converted to integers;
- operations that require converting integers to floating point are deferred until a native numerical value is requested.

NOTE: Support for radicals is very experimental.

For the reasons outlined at https://forums.swift.org/t/why-does-swift-not-support-rational-numbers/62725, this kind of abstraction isn't feasible in a general-purpose useful way. Noticeably, the performance penalty and the increased frequency of overflow issues make it applicable only in a subset of circumstances. You should kee that in mind if choosing this package for some specific use.

Goals of this package:

- ease of use
- correctness
- preserving integer math

Not goals:

- performance
- completeness of mathematical API

# Examples

```swift
    let m: Nuggle = 2.5
    let n: Nuggle = 1.5
    let p: Nuggle = 1

    let ex: Nuggle = 2.5 + 1.5 + 1

    XCTAssertEqual(m + n + p, ex)

    XCTAssertEqual(m + n, 4)
    XCTAssertEqual(m + n + p, 5)
    XCTAssertEqual(m + n + p, 4 + 1.6/4.8 + 2/3)

    XCTAssertEqual(m / n, 5 / 3)
    XCTAssertEqual((m / n).description, "5/3")

    XCTAssertEqual(ex.exactInt(), 5)

    XCTAssertEqual((m * 3).double(), 7.5)
```

## License

Except where/if otherwise specified, all the files in this package are copyright of the package contributors mentioned in the `NOTICE` file and licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0), which is permissive for business use.
