// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "blog",
    platforms: [
      .macOS(.v12),
    ],
    products: [
        .library(
            name: "blog",
            targets: [
                "blog"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", branch: "main"),
    ],
    targets: [
        .target(
            name: "blog",
            dependencies: []
        )
    ]
)
