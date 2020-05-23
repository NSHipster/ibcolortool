import ArgumentParser
import Foundation
import IBDecodable

extension Color {
    enum Format: String, ExpressibleByArgument {
        case rgbHexadecimal = "hex"
        case uicolorDeclaration = "uicolor"

        func representation(of color: Color) -> String? {
            switch self {
            case .rgbHexadecimal:
                switch color {
                case .sRGB(let components):
                    return String(format: "#%02X%02X%02X", UInt8(components.red * 255), UInt8(components.green * 255), UInt8(components.blue * 255))
                case .calibratedRGB(let components):
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
                case .calibratedRGB(let components):
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
