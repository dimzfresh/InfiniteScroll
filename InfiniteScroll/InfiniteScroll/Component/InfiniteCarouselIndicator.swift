import SwiftUI

struct InfiniteCarouselIndicator: View {
    let dragWidth: Double
    let isActive: Bool
    let fillProgress: Double

    private let minWidth: Double
    private let maxWidth: Double
    private let height: Double
    private let cornerRadius: Double
    private let backgroundColor: Color
    private let fillColor: Color

    init(
        dragWidth: Double,
        isActive: Bool,
        fillProgress: Double,
        minWidth: Double = 8,
        maxWidth: Double = 24,
        height: Double = 6,
        cornerRadius: Double = 3,
        backgroundColor: Color = .gray.opacity(0.7),
        fillColor: Color = .black
    ) {
        self.dragWidth = dragWidth
        self.isActive = isActive
        self.fillProgress = fillProgress
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.fillColor = fillColor
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .frame(width: currentWidth, height: height)
                .animation(.easeInOut(duration: 0.1), value: dragWidth)
                .animation(.easeInOut(duration: 0.1), value: fillProgress)

            if isActive {
                Rectangle()
                    .fill(fillColor)
                    .frame(width: fillWidth, height: height)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var currentWidth: Double {
        minWidth + (maxWidth - minWidth) * dragWidth
    }

    private var fillWidth: Double {
        currentWidth * fillProgress
    }
}
