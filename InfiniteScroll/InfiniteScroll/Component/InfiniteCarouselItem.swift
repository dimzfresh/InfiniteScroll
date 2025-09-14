import SwiftUI

struct InfiniteCarouselItem<Element: Identifiable & Hashable>: Identifiable, Hashable {
    let id: String
    let item: Element

    init(
        id: String = UUID().uuidString,
        _ item: Element
    ) {
        self.id = id
        self.item = item
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(item)
    }

    static func == (lhs: InfiniteCarouselItem, rhs: InfiniteCarouselItem) -> Bool {
        lhs.id == rhs.id && lhs.item == rhs.item
    }
}
