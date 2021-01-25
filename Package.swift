// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BogusApp-Common-Networking",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BogusApp-Common-Networking",
            targets: ["BogusApp-Common-Networking"]),
    ],
    dependencies: [
        .package(name: "BogusApp-Common-Utils", url: "../BogusApp-Common-Utils", .branch("master")),
        
        // SwiftLint & Komondor
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"),
        .package(url: "https://github.com/orta/Komondor", from: "1.0.6"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BogusApp-Common-Networking",
            dependencies: [.product(name: "BogusApp-Common-Utils", package: "BogusApp-Common-Utils")]),
        .testTarget(
            name: "BogusApp-Common-NetworkingTests",
            dependencies: ["BogusApp-Common-Networking"]),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift test",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
    ]).write()
#endif

