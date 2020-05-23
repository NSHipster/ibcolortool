import class Foundation.Bundle
import XCTest

final class IBColorToolTests: XCTestCase {
    func testUIColorDeclarationFormatXIB() throws {
        let xibFilePath = (try temporaryFile(contents: xib, extension: "xib")).path
        let actual = try runIBColorTool(with: [xibFilePath])
        let expected = "UIColor(red: 1.0, green: 0.5763723, blue: 0.0, alpha: 1.0)\n"

        XCTAssertEqual(actual, expected)
    }

    func testRGBHexFormatXIB() throws {
        let xibFilePath = (try temporaryFile(contents: xib, extension: "xib")).path
        let actual = try runIBColorTool(with: ["--format", "hex", xibFilePath])
        let expected = "#FF9200\n"

        XCTAssertEqual(actual, expected)
    }

    func testUIColorDeclarationFormatStoryboard() throws {
        let storyboardFilePath = (try temporaryFile(contents: storyboard, extension: "storyboard")).path
        let actual = try runIBColorTool(with: [storyboardFilePath])
        let expected = "UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)\n"

        XCTAssertEqual(actual, expected)
    }

    func testRGBHexFormatStoryboard() throws {
        let storyboardFilePath = (try temporaryFile(contents: storyboard, extension: "storyboard")).path
        let actual = try runIBColorTool(with: ["--format", "hex", storyboardFilePath])
        let expected = "#00FF00\n"

        XCTAssertEqual(actual, expected)
    }

    func testStoryboardAndXIBWithObjectID() throws {
        let storyboardFilePath = (try temporaryFile(contents: storyboard, extension: "storyboard")).path
        let xibFilePath = (try temporaryFile(contents: xib, extension: "xib")).path
        let actual = try runIBColorTool(with: [
                            "--format", "hex",
                            "--include-object-id",
                            storyboardFilePath,
                            xibFilePath
                         ])

        let expected = """
        3Dd-xk-CM4\t#00FF00
        iN0-l3-epB\t#FF9200

        """

        XCTAssertEqual(actual, expected)
    }
}
