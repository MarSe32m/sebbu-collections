// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "sebbu-collections",
    platforms: [.macOS(.v15), .iOS(.v16)],
    products: [
        .library(
            name: "SebbuCollections",
            targets: ["SebbuCollections"]),
    ],
    dependencies: [.package(url: "https://github.com/apple/swift-collections.git", from: "1.4.0")],
    targets: [
        .target(name: "SebbuCollections",
                dependencies: [.product(name: "Collections", package: "swift-collections")]),
        .testTarget(
            name: "SebbuCollectionsTests",
            dependencies: ["SebbuCollections"]),
    ]
)
