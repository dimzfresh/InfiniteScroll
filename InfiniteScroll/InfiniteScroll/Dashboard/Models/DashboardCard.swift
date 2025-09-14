import SwiftUI

struct DashboardCard: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let value: String
    let change: String
    let changeType: ChangeType
    let chartData: [Double]
    let gradient: LinearGradient
    
    enum ChangeType {
        case positive, negative, neutral
    }
    
    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        value: String,
        change: String,
        changeType: ChangeType,
        chartData: [Double],
        gradient: LinearGradient
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.change = change
        self.changeType = changeType
        self.chartData = chartData
        self.gradient = gradient
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(value)
    }
    
    static func == (lhs: DashboardCard, rhs: DashboardCard) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}
