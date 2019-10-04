import Foundation
import IBDecodable
import Commander

extension Color {
    enum Format {
        case rgbHexadecimal
        case uicolorDeclaration

        func representation(of color: Color) -> String? {
            switch self {
            case .rgbHexadecimal:
                switch color {
                case .sRGB(let components):
                    return String(format: "#%02X%02X%02X", UInt8(components.red * 255), UInt8(components.green * 255), UInt8(components.blue * 255))
                case .calibratedWhite(let components):
                    return String(format: "#%02X%02X%02X", arguments: Array(repeating: UInt8(components.white * 255), count: 3))
                default:
                    return nil
                }
            case .uicolorDeclaration:
                switch color {
                case .sRGB(let components):
                    return "UIColor(red: \(components.red), green: \(components.green), blue: \(components.blue), alpha: \(components.alpha))"
                case .calibratedWhite(let components):
                    return "UIColor(white: \(components.white), alpha: \(components.alpha))"
                case .name(let components):
                    return "UIColor(named: \(components.name))"
                case .systemColor(let components):
                    return "UIColor.\(components.name)"
                }
            }
        }
    }
}

// MARK: - ArgumentConvertible

extension Color.Format: ArgumentConvertible {
    var description: String {
        switch self {
        case .rgbHexadecimal:
            return "hex"
        case .uicolorDeclaration:
            return "uicolor"
        }
    }

    init(parser: ArgumentParser) throws {
        switch parser.shift() {
        case "hex":
            self = .rgbHexadecimal
        default:
            self = .uicolorDeclaration
        }
    }
}
