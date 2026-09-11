import SwiftData
import SwiftUI

/// Root view displaying all persisted workout sessions.
struct WorkoutListView: View {
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
				ForEach(sessions) { session in
					VStack(alignment: .leading, spacing: 4) {
						Text(session.name)
							.font(.headline)

						HStack {
							Text(session.startDate.formatted(date: .abbreviated, time: .shortened))
								.font(.caption)
								.foregroundStyle(.secondary)

							Spacer()

							Text("\(session.exerciseLogs.count) exercises")
								.font(.caption)
								.foregroundStyle(.secondary)
						}
					}
					.padding(.vertical, 4)
				}
			}
		}
		.navigationTitle("Workouts")
		.toolbar {
			Button(
				action: {},
				label: {
					Image(systemName: "plus")
				}
			)
		}
	}
}

#Preview {
	NavigationStack {
		WorkoutListView()
	}
	.modelContainer(PreviewContainer.sample)
}
