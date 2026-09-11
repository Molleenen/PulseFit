import SwiftUI

/// Root view displaying summary statistics and workout volume analytics.
struct AnalyticsOverviewView: View {
	var body: some View {
		ContentUnavailableView(
			"Analytics Coming Soon",
			systemImage: "chart.bar.fill",
			description: Text("Volume trends and muscle group breakdowns will appear here.")
		)
		.navigationTitle("Analytics")
	}
}

#Preview {
	NavigationStack {
		AnalyticsOverviewView()
	}
}
