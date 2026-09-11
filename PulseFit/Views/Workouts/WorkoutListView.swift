import SwiftData
import SwiftUI

/// Root view displaying all persisted workout sessions with date grouping and swipe deletion.
struct WorkoutListView: View {
	@Environment(\.modelContext) private var modelContext

	@Query(sort: \WorkoutSession.startDate, order: .reverse)
	private var sessions: [WorkoutSession]

	var body: some View {
		List {
			if sessions.isEmpty {
				ContentUnavailableView(
					"No Workouts Yet",
					systemImage: "figure.run.circle",
					description: Text("Start a new workout session to track your progress.")
				)
			} else {
				ForEach(sortedSectionKeys, id: \.self) { sectionTitle in
					Section(header: Text(sectionTitle)) {
						if let sectionSessions = groupedSessions[sectionTitle] {
							ForEach(sectionSessions) { session in
								NavigationLink(value: session) {
									WorkoutCardView(session: session)
								}
							}
							.onDelete { indexSet in
								deleteSessions(in: sectionSessions, at: indexSet)
							}
						}
					}
				}
			}
		}
		.navigationTitle("Workouts")
		.navigationDestination(for: WorkoutSession.self) { session in
			WorkoutDetailView(session: session)
		}
		.toolbar {
			Button(
				action: {},
				label: {
					Image(systemName: "plus")
				}
			)
		}
	}

	// MARK: - Section Grouping

	private var groupedSessions: [String: [WorkoutSession]] {
		let calendar = Calendar.current
		return Dictionary(grouping: sessions) { session in
			if calendar.isDateInToday(session.startDate) {
				"Today"
			} else if calendar.isDateInYesterday(session.startDate) {
				"Yesterday"
			} else if calendar.isDate(session.startDate, equalTo: Date(), toGranularity: .weekOfYear) {
				"This Week"
			} else {
				"Earlier"
			}
		}
	}

	private var sortedSectionKeys: [String] {
		let order = ["Today", "Yesterday", "This Week", "Earlier"]
		return order.filter { groupedSessions.keys.contains($0) }
	}

	// MARK: - Actions

	private func deleteSessions(in sectionSessions: [WorkoutSession], at indexSet: IndexSet) {
		for index in indexSet {
			let sessionToDelete = sectionSessions[index]
			modelContext.delete(sessionToDelete)
		}
	}
}

#Preview { @MainActor in
	NavigationStack {
		WorkoutListView()
	}
	.modelContainer(PreviewContainer.sample)
}
