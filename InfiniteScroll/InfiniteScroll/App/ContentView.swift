import SwiftUI

struct ContentView: View {
    @State private var cards: [DashboardCard] = []

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    Spacer()

                    InfiniteCarouselView(
                        data: cards,
                        spacing: 16,
                        itemSize: .init(width: geometry.size.width - 64, height: 280)
                    ) { card in
                        DashboardCardView(card: card)
                    }

                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    init(cards: [DashboardCard] = DashboardCardFactory.buildCards()) {
        _cards = .init(initialValue: cards)
    }
}

#Preview {
    ContentView()
}
