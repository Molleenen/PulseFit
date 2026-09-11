import SwiftData
import SwiftUI

/// The root navigation tab shell for PulseFit using modern iOS Tab APIs.
struct MainTabView: View {
	@State private var selectedTab: AppTab = .workouts

	/// Represents the main root tab destinations.
	enum AppTab: Hashable {
		case workouts
		case analytics
	}

	var body: some View {
		TabView(selection: $selectedTab) {
			Tab(
				"Workouts",
				systemImage: "figure.run",
				value: .workouts
			) {
				NavigationStack {
					WorkoutListView()
				}
			}

			Tab(
				"Analytics",
				systemImage: "chart.bar.fill",
				value: .analytics
			) {
				NavigationStack {
					AnalyticsOverviewView()
				}
			}
		}
	}
}

#Preview {
	MainTabView()
		.modelContainer(PreviewContainer.sample)
}
