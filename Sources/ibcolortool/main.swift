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

    func run() throws {
        var colors: [IBDecodable.Color] = []

        guard !inputs.isEmpty else {
            print(IBColorTool.helpMessage())
            return
        }

        for fileURL in inputs {
            do {
                switch fileURL.pathExtension.lowercased() {
                case "storyboard":
                    let file = try StoryboardFile(url: fileURL)
                    colors.append(contentsOf: file.colors)
                case "xib":
                    let file = try XibFile(url: fileURL)
                    colors.append(contentsOf: file.colors)
                default:
                    print("Unknown file extension: ", fileURL.pathExtension, to: &standardError)
                }
            } catch {
                print(fileURL, error, to: &standardError)
                continue
            }
        }

        print(colors.compactMap { format.representation(of: $0) }.joined(separator: "\n"), to: &standardOutput)
    }
}

IBColorTool.main()
