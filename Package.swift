// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Nuggle",
    products: [
        .library(
            name: "Nuggle",
            targets: ["Nuggle"]),
    ],
    targets: [
        .target(
            name: "Nuggle"),
        .testTarget(
            name: "NuggleTests",
            dependencies: ["Nuggle"]),
    ]
)
