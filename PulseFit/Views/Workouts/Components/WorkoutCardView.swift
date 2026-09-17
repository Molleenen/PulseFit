import SwiftData
import SwiftUI

/// Summary card component displayed in workout lists.
struct WorkoutCardView: View {
	let session: WorkoutSession

	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Text(session.name)
					.font(.headline)

				Spacer()

				Text(session.formattedDuration)
					.font(.caption.bold())
					.padding(.horizontal, 8)
					.padding(.vertical, 4)
					.background(Color.accentColor.opacity(0.12))
					.foregroundStyle(Color.accentColor)
					.clipShape(Capsule())
			}

			HStack(spacing: 12) {
				Label(session.startDate.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
					.font(.caption)
					.foregroundStyle(.secondary)

				Spacer()

				Label("\(session.exerciseLogs.count) exercises", systemImage: "dumbbell.fill")
					.font(.caption)
					.foregroundStyle(.secondary)
			}

			if !session.sortedMuscleGroups.isEmpty {
				HStack(spacing: 6) {
					ForEach(session.sortedMuscleGroups, id: \.self) { group in
						Text(group)
							.font(.caption2)
							.padding(.horizontal, 6)
							.padding(.vertical, 2)
							.background(Color.secondary.opacity(0.15))
							.foregroundStyle(.secondary)
							.cornerRadius(4)
					}
				}
			}
		}
		.padding(.vertical, 4)
	}
}

#Preview {
	List {
		if let session = try? PreviewContainer.sample.mainContext.fetch(FetchDescriptor<WorkoutSession>()).first {
			WorkoutCardView(session: session)
		}
	}
	.modelContainer(PreviewContainer.sample)
}
