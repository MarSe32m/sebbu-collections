// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sebbu-collections",
    platforms: [.macOS(.v15), .iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SebbuCollections",
            targets: ["SebbuCollections"]),
    ],
    dependencies: [.package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "SebbuCollections",
                dependencies: [.product(name: "Collections", package: "swift-collections")]),
        .testTarget(
            name: "SebbuCollectionsTests",
            dependencies: ["SebbuCollections"]),
    ]
)
