import Commander
import Foundation
import IBDecodable

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let fileManager = FileManager.default

var standardOutput = FileHandle.standardOutput
var standardError = FileHandle.standardError

command(
    Option<Color.Format>("format", default: .uicolorDeclaration),
    Argument<[String]>("paths", description: "One or more paths to XIB or Storyboard files", validator: { (paths) -> [String] in
        paths.filter { path in fileManager.fileExists(atPath: path) }
    })
) { format, paths in
    var colors: [IBDecodable.Color] = []

    for path in paths {
        guard fileManager.fileExists(atPath: path) else { continue }
        let fileURL = URL(fileURLWithPath: path)

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
            print(path, error, to: &standardError)
            continue
        }
    }

    print(colors.compactMap { format.representation(of: $0) }.joined(separator: "\n"), to: &standardOutput)
}.run()
