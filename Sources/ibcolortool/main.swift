import ArgumentParser
import Foundation
import IBDecodable

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let fileManager = FileManager.default

var standardOutput = FileHandle.standardOutput
var standardError = FileHandle.standardError

struct IBColorTool: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "ibcolortool",
        abstract: "Lists the colors used in Storyboards and XIB files.",
        version: "0.0.1"
    )

    @Argument(help: "One or more paths to XIB or Storyboard files",
              transform: { URL(fileURLWithPath: $0) })
    var inputs: [URL]

    @Option(default: .uicolorDeclaration,
            help: "Representation format for colors.")
    var format: Color.Format

    @Flag(help: "Include the color's corresponding Object ID")
    var includeObjectID: Bool

    func run() throws {
        var entries: [Entry] = []

        guard !inputs.isEmpty else {
            print(IBColorTool.helpMessage())
            return
        }

        for fileURL in inputs {
            do {
                switch fileURL.pathExtension.lowercased() {
                case "storyboard":
                    let file = try StoryboardFile(url: fileURL)
                    entries.append(contentsOf: file.entries)
                case "xib":
                    let file = try XibFile(url: fileURL)
                    entries.append(contentsOf: file.entries)
                default:
                    print("Unknown file extension: ", fileURL.pathExtension, to: &standardError)
                }
            } catch {
                print(fileURL, error, to: &standardError)
                continue
            }
        }

        let lines: [String] = entries.compactMap { entry in
            let id = entry.element?.id
            let representation = format.representation(of: entry.color)

            guard id != nil || representation != nil else { return nil }

            if includeObjectID {
                return "\(id ?? "")\t\(representation ?? "")"
            } else {
                return representation ?? ""
            }
        }

        print(lines.joined(separator: "\n"), to: &standardOutput)
    }
}

IBColorTool.main()
