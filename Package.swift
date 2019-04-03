// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Fractions",
    products: [
        .executable(name: "Fractions", targets: ["Fractions"]),
        // executable modules aren't testable :(
        // https://stackoverflow.com/questions/54454250/swift-unit-test-error-symbols-not-found-for-architecture-x86-64-swift-packag
        .library(name: "FractionKit", targets: ["FractionKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Fractions",
            dependencies: ["FractionKit"]),
        .target(
            name: "FractionKit",
            dependencies: []),
        .testTarget(
            name: "FractionsTests",
            dependencies: ["FractionKit"]),
    ]
)
