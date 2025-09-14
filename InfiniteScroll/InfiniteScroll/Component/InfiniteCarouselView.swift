import SwiftUI

struct InfiniteCarouselView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable & Hashable {
    let data: Data
    let spacing: CGFloat
    let itemSize: CGSize
    let content: (Data.Element) -> Content

    @State private var state = InfiniteCarouselState()
    @State private var extendedData: [InfiniteCarouselItem<Data.Element>]
    @State private var scrollProxy: ScrollViewProxy?
    @State private var autoScrollTimer: Timer?

    init(
        data: Data,
        spacing: CGFloat = 0,
        itemSize: CGSize = CGSize(width: 300, height: 300),
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.spacing = spacing
        self.itemSize = itemSize
        self.content = content

        let firstItems: [InfiniteCarouselItem] = Array(data).map { .init($0) }
        let secondItems: [InfiniteCarouselItem] = Array(data).map { .init($0) }
        let thirdItems: [InfiniteCarouselItem] = Array(data).map { .init($0) }

        if data.count > 1 {
            _extendedData = .init(initialValue: firstItems + secondItems + thirdItems)
            _state = .init(initialValue: InfiniteCarouselState(
                currentItemIndex: data.count,
                currentArrayIndex: 1
            ))
        } else {
            _extendedData = .init(initialValue: firstItems)
            _state = .init(initialValue: InfiniteCarouselState())
        }
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(Array(extendedData.enumerated()), id: \.offset) { index, infiniteItem in
                                content(infiniteItem.item)
                                    .frame(width: itemSize.width, height: itemSize.height)
                                    .tag(index)
                            }
                        }
                    }
                    .frame(height: itemSize.height)
                    .disabled(data.count <= 1 || state.isSwappingArrays)
                    .simultaneousGesture(createDragGesture())
                    .onAppear {
                        setupScrollView(proxy: proxy)
                    }
                    .onDisappear {
                        stopAutoScroll()
                    }
                }
            }
            .frame(height: itemSize.height)
            .overlay {
                createPageIndicators()
            }
        }
    }
    
    // MARK: - Drag Gesture
    private func createDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                state.isDragging = true
                state.dragOffset = value.translation.width
                resetAutoScroll()
            }
            .onEnded { value in
                state.isDragging = false
                state.dragOffset = 0
                handleDragEnd(translation: value.translation.width, velocity: value.velocity.width)
                startAutoScroll()
            }
    }
    
    private func handleDragEnd(translation: CGFloat, velocity: CGFloat) {
        let threshold = itemSize.width * 0.3
        let shouldSwitch = abs(translation) > threshold || abs(velocity) > 800

        if shouldSwitch {
            if translation > 0 || velocity > 0 {
                moveToPrevious()
            } else {
                moveToNext()
            }
        } else {
            moveToCurrent()
        }
    }
    
    // MARK: - Scroll View Setup
    private func setupScrollView(proxy: ScrollViewProxy) {
        scrollProxy = proxy
        
        let itemsCount = Array(data).count
        state.currentItemIndex = itemsCount

        Task {
            proxy.scrollTo(state.currentItemIndex, anchor: .center)
        }
        
        startAutoScroll()
    }
    
    // MARK: - Page Indicators
    private func createPageIndicators() -> some View {
        Group {
            if data.count > 1 {
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 4) {
                        ForEach(0..<Array(data).count, id: \.self) { index in
                            InfiniteCarouselIndicator(
                                dragWidth: indicatorProgress(for: index),
                                isActive: index == (state.currentItemIndex % Array(data).count),
                                fillProgress: index == (state.currentItemIndex % Array(data).count) ? state.progress : 0.0
                            )
                        }
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }
    
    private func indicatorProgress(for index: Int) -> Double {
        let itemsCount = Array(data).count
        guard itemsCount > 0 else { return 0.0 }
        
        let realIndex = state.currentItemIndex % itemsCount

        if state.isDragging {
            return calculateDragProgress(for: index, realIndex: realIndex, itemsCount: itemsCount)
        } else {
            return index == realIndex ? 1.0 : 0.0
        }
    }
    
    private func calculateDragProgress(for index: Int, realIndex: Int, itemsCount: Int) -> Double {
        let dragProgress = state.dragOffset / itemSize.width
        let targetIndex = (state.currentItemIndex + (state.dragOffset > 0 ? -1 : 1)) % itemsCount

        if index == realIndex {
            return max(0.0, 1.0 - abs(dragProgress))
        } else if index == targetIndex {
            return min(1.0, abs(dragProgress))
        } else {
            return 0.0
        }
    }
    
    // MARK: - Navigation
    private func moveToNext() {
        state.currentItemIndex += 1
        updateArrayIndex()
        resetProgress()
        animateToCurrent()
    }

    private func moveToPrevious() {
        state.currentItemIndex -= 1
        updateArrayIndex()
        resetProgress()
        animateToCurrent()
    }
    
    private func moveToCurrent() {
        animateToCurrent()
    }
    
    private func resetProgress() {
        withAnimation(.easeInOut(duration: 0.2)) {
            state.progress = 0.0
        }
    }
    
    // MARK: - Array Management
    private func updateArrayIndex() {
        let itemsCount = Array(data).count

        if state.currentItemIndex < itemsCount {
            state.currentArrayIndex = 0
        } else if state.currentItemIndex < itemsCount * 2 {
            state.currentArrayIndex = 1
        } else {
            state.currentArrayIndex = 2
        }
    }
    
    private func animateToCurrent() {
        Task {
            let itemsCount = Array(data).count
            let shouldSwapForward = state.currentArrayIndex == 2 && state.currentItemIndex % itemsCount == 0
            let shouldSwapBackward = state.currentArrayIndex == 0 && state.currentItemIndex % itemsCount == itemsCount - 1
            
            if shouldSwapForward || shouldSwapBackward {
                performSwapAnimation()
            } else {
                performRegularAnimation()
            }
        }
    }
    
    private func performSwapAnimation() {
        state.isSwappingArrays = true
        
        withAnimation(.easeInOut(duration: 0.3)) {
            scrollProxy?.scrollTo(state.currentItemIndex, anchor: .center)
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            swapArraysIfNeeded()
        }
    }
    
    private func performRegularAnimation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            scrollProxy?.scrollTo(state.currentItemIndex, anchor: .center)
        }
    }
    
    private func swapArraysIfNeeded() {
        let itemsCount = Array(data).count
        guard itemsCount > 1 else { return }
        
        if state.currentArrayIndex == 2 && state.currentItemIndex % itemsCount == 0 {
            swapForward(itemsCount: itemsCount)
        } else if state.currentArrayIndex == 0 && state.currentItemIndex % itemsCount == itemsCount - 1 {
            swapBackward(itemsCount: itemsCount)
        }
        
        Task {
            scrollProxy?.scrollTo(state.currentItemIndex, anchor: .center)
        }
        
        state.isSwappingArrays = false
    }
    
    private func swapForward(itemsCount: Int) {
        let originalItems: [InfiniteCarouselItem] = Array(data).map { .init($0) }
        extendedData = originalItems + originalItems + originalItems
        state.currentArrayIndex = 1
        state.currentItemIndex = itemsCount
    }
    
    private func swapBackward(itemsCount: Int) {
        let originalItems: [InfiniteCarouselItem] = Array(data).map { .init($0) }
        extendedData = originalItems + originalItems + originalItems
        state.currentArrayIndex = 1
        state.currentItemIndex = itemsCount * 2 - 1
    }
    
    // MARK: - Auto Scroll
    private func startAutoScroll() {
        guard Array(data).count > 1 else { return }
        
        stopAutoScroll()
        
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
            if !state.isDragging && !state.isSwappingArrays {
                state.progress += 1.0 / (5.0 * 60.0)
                
                if state.progress >= 1.0 {
                    state.progress = 0.0
                    moveToNext()
                }
            }
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func resetAutoScroll() {
        withAnimation(.easeInOut(duration: 0.2)) {
            state.progress = 0.0
        }
        stopAutoScroll()
    }

    private struct InfiniteCarouselState {
        var currentItemIndex = 0
        var currentArrayIndex = 1
        var isDragging = false
        var dragOffset: CGFloat = 0
        var isSwappingArrays = false
        var progress: Double = 0.0
    }
}
