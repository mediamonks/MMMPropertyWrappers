// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MMMPropertyWrappers",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "MMMPropertyWrappers",
            targets: ["MMMPropertyWrappers"]
		)
    ],
    dependencies: [
		.package(url: "https://github.com/mediamonks/MMMObservables", .upToNextMajor(from: "1.2.0")),
		.package(url: "https://github.com/mattgallagher/CwlPreconditionTesting", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "MMMPropertyWrappers",
            dependencies: [
				"MMMObservables"
            ]
		),
        .testTarget(
            name: "MMMPropertyWrapperTests",
            dependencies: [
				"MMMPropertyWrappers",
				"CwlPreconditionTesting",
				.product(name: "CwlPosixPreconditionTesting", package: "CwlPreconditionTesting")
			]
		)
    ]
)
