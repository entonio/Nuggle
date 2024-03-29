// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
