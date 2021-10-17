import IBDecodable

typealias Entry = (element: IBIdentifiable?, color: Color)

fileprivate final class InterfaceBuilderElementVisitor {
    var entries: [Entry] = []

    func visit(element: IBElement) -> Bool {
        for child in Mirror(reflecting: element).children {
            if let color = child.value as? Color {
                entries.append((element as? IBIdentifiable, color))
            }
        }

        return true
    }
}

extension StoryboardFile {
    var entries: [Entry] {
        let visitor = InterfaceBuilderElementVisitor()
        _ = document.browse(visitor.visit(element:))
        return visitor.entries
    }
}

extension XibFile {
    var entries: [Entry] {
        let visitor = InterfaceBuilderElementVisitor()
        _ = document.browse(visitor.visit(element:))
        return visitor.entries
    }
}
