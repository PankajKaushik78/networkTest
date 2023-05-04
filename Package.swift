// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "NetworkCapture",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "NetworkCapture",
            targets: ["NetworkCapture"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NetworkCapture",
            dependencies: [],
            path: "NetworkCapture")
    ]
)
