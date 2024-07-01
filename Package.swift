// swift-tools-version: 5.9

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
