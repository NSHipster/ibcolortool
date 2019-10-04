import IBDecodable

fileprivate final class InterfaceBuilderElementVisitor {
    var colors: [Color] = []

    func visit(element: IBElement) -> Bool {
        for child in Mirror(reflecting: element).children {
            if let color = child.value as? Color {
                colors.append(color)
            }
        }

        return true
    }
}

extension StoryboardFile {
    var colors: [Color] {
        let visitor = InterfaceBuilderElementVisitor()
        _ = document.browse(visitor.visit(element:))
        return visitor.colors
    }
}

extension XibFile {
    var colors: [Color] {
        let visitor = InterfaceBuilderElementVisitor()
        _ = document.browse(visitor.visit(element:))
        return visitor.colors
    }
}
