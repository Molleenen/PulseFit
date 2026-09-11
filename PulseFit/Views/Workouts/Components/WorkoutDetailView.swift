import SwiftData
import SwiftUI

/// Detailed breakdown view for a single workout session.
struct WorkoutDetailView: View {
	let session: WorkoutSession

	var body: some View {
		List {
			Section("Summary") {
				HStack {
					Label("Duration", systemImage: "clock")
					Spacer()
					Text(formattedDuration)
						.foregroundStyle(.secondary)
				}

				HStack {
					Label("Started", systemImage: "play.circle")
					Spacer()
					Text(session.startDate.formatted(date: .abbreviated, time: .shortened))
						.foregroundStyle(.secondary)
				}

				if let endDate = session.endDate {
					HStack {
						Label("Ended", systemImage: "stop.circle")
						Spacer()
						Text(endDate.formatted(date: .abbreviated, time: .shortened))
							.foregroundStyle(.secondary)
					}
				}

				if let notes = session.notes, !notes.isEmpty {
					VStack(alignment: .leading, spacing: 4) {
						Text("Notes")
							.font(.caption)
							.foregroundStyle(.secondary)
						Text(notes)
							.font(.subheadline)
					}
					.padding(.vertical, 2)
				}
			}

			if session.exerciseLogs.isEmpty {
				ContentUnavailableView(
					"No Exercises Recorded",
					systemImage: "dumbbell",
					description: Text("This workout session has no exercise logs attached.")
				)
			} else {
				ForEach(session.exerciseLogs) { exercise in
					Section {
						if let notes = exercise.notes, !notes.isEmpty {
							Text(notes)
								.font(.caption)
								.foregroundStyle(.secondary)
						}

						ForEach(exercise.sets.sorted(by: { $0.index < $1.index })) { set in
							SetRowView(set: set)
						}
					} header: {
						HStack {
							Text(exercise.exerciseName)
								.font(.headline)
								.foregroundStyle(.primary)

							Spacer()

							if let muscleGroup = exercise.muscleGroup {
								Text(muscleGroup)
									.font(.caption)
									.foregroundStyle(.secondary)
							}
						}
					}
				}
			}
		}
		.navigationTitle(session.name)
		.navigationBarTitleDisplayMode(.inline)
	}

	private var formattedDuration: String {
		guard let duration = session.duration else {
			return "In Progress"
		}

		let totalSeconds = Int(duration)
		let minutes = (totalSeconds % 3_600) / 60
		let hours = totalSeconds / 3_600

		if hours > 0 {
			return "\(hours)h \(minutes)m"
		} else {
			return "\(minutes)m"
		}
	}
}

#Preview {
	NavigationStack {
		if let session = try? PreviewContainer.sample.mainContext.fetch(FetchDescriptor<WorkoutSession>()).first {
			WorkoutDetailView(session: session)
		}
	}
	.modelContainer(PreviewContainer.sample)
}
