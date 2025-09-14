import SwiftUI

struct MiniChartView: View {
    let data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let maxValue = data.max() ?? 1
                let minValue = data.min() ?? 0
                let range = maxValue - minValue
                
                guard range > 0 else { return }
                
                let stepX = geometry.size.width / CGFloat(data.count - 1)
                let stepY = geometry.size.height / range
                
                for (index, value) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = geometry.size.height - ((value - minValue) * stepY)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(
                LinearGradient(
                    colors: [.white.opacity(0.8), .white.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
            
            Path { path in
                let maxValue = data.max() ?? 1
                let minValue = data.min() ?? 0
                let range = maxValue - minValue
                
                guard range > 0 else { return }
                
                let stepX = geometry.size.width / CGFloat(data.count - 1)
                let stepY = geometry.size.height / range
                
                for (index, value) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = geometry.size.height - ((value - minValue) * stepY)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                
                if let lastX = data.indices.last {
                    let x = CGFloat(lastX) * stepX
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
            }
            .fill(
                LinearGradient(
                    colors: [.white.opacity(0.3), .white.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}
