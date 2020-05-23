import Foundation

func runIBColorTool(with arguments: [String]) throws -> String {
    let process = Process()
    process.executableURL = productsDirectory.appendingPathComponent("ibcolortool")

    let pipe = Pipe()
    process.standardOutput = pipe

    process.arguments = arguments

    try process.run()
    process.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)!
}

var productsDirectory: URL {
    #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
    #else
        return Bundle.main.bundleURL
    #endif
}

func temporaryFile(contents: String, extension: String) throws -> URL {
    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    let temporaryFilename = UUID().uuidString

    let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(temporaryFilename).appendingPathExtension(`extension`)
    try contents.data(using: .utf8)?.write(to: temporaryFileURL, options: .atomic)

    return temporaryFileURL
}
