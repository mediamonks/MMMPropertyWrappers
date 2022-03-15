// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MMMPropertyWrappers",
    platforms: [
		.iOS(.v11),
        .watchOS(.v3),
        .tvOS(.v10),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "MMMPropertyWrappers",
            targets: ["MMMPropertyWrappers"]
		)
    ],
    dependencies: [
		.package(url: "https://github.com/mediamonks/MMMObservables", .upToNextMajor(from: "1.4.0"))
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
				"MMMPropertyWrappers"
			]
		)
    ]
)
