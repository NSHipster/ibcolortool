import class Foundation.Bundle
import XCTest

final class IBColorToolTests: XCTestCase {
    func testIBColorTool() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let process = Process()

        process.executableURL = productsDirectory.appendingPathComponent("ibcolortool")

        let pipe = Pipe()
        process.standardOutput = pipe

        process.arguments = [(try temporaryXIBFile()).path]

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "UIColor(red: 1.0, green: 0.5763723, blue: 0.0, alpha: 1.0)\n")
    }

    private var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }

    static var allTests = [
        ("testIBColorTool", testIBColorTool),
    ]
}

fileprivate func temporaryXIBFile() throws -> URL {
    let xib = #"""
    <?xml version="1.0" encoding="UTF-8"?>
    <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="14868" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES">
        <device id="retina6_1" orientation="portrait" appearance="light"/>
        <dependencies>
            <deployment identifier="iOS"/>
            <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="14824"/>
            <capability name="Safe area layout guides" minToolsVersion="9.0"/>
            <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
        </dependencies>
        <objects>
            <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner"/>
            <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
            <view contentMode="scaleToFill" id="iN0-l3-epB">
                <rect key="frame" x="0.0" y="0.0" width="414" height="896"/>
                <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                <color key="backgroundColor" red="1" green="0.57637232540000005" blue="0.0" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
                <viewLayoutGuide key="safeArea" id="vUN-kp-3ea"/>
                <point key="canvasLocation" x="139" y="92"/>
            </view>
        </objects>
    </document>

    """#

    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    let temporaryFilename = ProcessInfo().globallyUniqueString

    let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(temporaryFilename).appendingPathExtension("xib")
    try xib.data(using: .utf8)?.write(to: temporaryFileURL, options: .atomic)

    return temporaryFileURL
}
