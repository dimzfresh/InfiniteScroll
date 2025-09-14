import SwiftUI

struct DashboardCardView: View {
    let card: DashboardCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(card.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(card.value)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Image(systemName: changeIcon)
                            .font(.caption)
                            .foregroundColor(changeColor)
                        
                        Text(card.change)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(changeColor)
                    }
                }
            }
            
            MiniChartView(data: card.chartData)
                .frame(height: 60)
        }
        .padding(20)
        .background(card.gradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var changeIcon: String {
        switch card.changeType {
        case .positive: return "arrow.up.right"
        case .negative: return "arrow.down.right"
        case .neutral: return "minus"
        }
    }
    
    private var changeColor: Color {
        switch card.changeType {
        case .positive: return .green
        case .negative: return .red
        case .neutral: return .gray
        }
    }
}
