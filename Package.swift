// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "minna-kirai-da",
    platforms: [.macOS("10.15")],
    dependencies: [
        .package(url: "https://github.com/mironal/TwitterAPIKit", .upToNextMajor(from: "0.1.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "minna-kirai-da",
            dependencies: [
                "TwitterAPIKit"
            ]),
        .testTarget(
            name: "minna-kirai-daTests",
            dependencies: ["minna-kirai-da"]),
    ]
)
