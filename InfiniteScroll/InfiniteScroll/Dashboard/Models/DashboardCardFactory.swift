import SwiftUI

enum DashboardCardFactory {
    static func buildCards() -> [DashboardCard] {
        [
            .init(
                title: "Sales",
                subtitle: "This month",
                value: "$12,345",
                change: "+12.5%",
                changeType: .positive,
                chartData: [20, 35, 25, 45, 30, 55, 40, 60, 50, 70, 65, 80],
                gradient: LinearGradient(
                    colors: [.blue.opacity(0.8), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            .init(
                title: "Users",
                subtitle: "Active",
                value: "2,847",
                change: "+8.2%",
                changeType: .positive,
                chartData: [10, 25, 15, 30, 20, 40, 35, 50, 45, 60, 55, 70],
                gradient: LinearGradient(
                    colors: [.green.opacity(0.8), .mint.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            .init(
                title: "Conversion",
                subtitle: "Website",
                value: "3.2%",
                change: "-2.1%",
                changeType: .negative,
                chartData: [30, 20, 35, 25, 40, 30, 45, 35, 50, 40, 45, 50],
                gradient: LinearGradient(
                    colors: [.orange.opacity(0.8), .red.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            .init(
                title: "Revenue",
                subtitle: "Total",
                value: "$45,678",
                change: "0.0%",
                changeType: .neutral,
                chartData: [40, 50, 45, 60, 55, 70, 65, 80, 75, 90, 85, 100],
                gradient: LinearGradient(
                    colors: [.indigo.opacity(0.8), .cyan.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            .init(
                title: "Orders",
                subtitle: "New",
                value: "156",
                change: "+15.3%",
                changeType: .positive,
                chartData: [15, 25, 20, 35, 30, 45, 40, 55, 50, 65, 60, 75],
                gradient: LinearGradient(
                    colors: [.pink.opacity(0.8), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ]
    }
}
