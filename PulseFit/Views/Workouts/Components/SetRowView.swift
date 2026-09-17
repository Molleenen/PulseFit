import SwiftUI

/// A row component rendering individual set metrics, badges, and completion status.
struct SetRowView: View {
	let set: WorkoutSet

	var body: some View {
		HStack(spacing: 12) {
			Text("Set \(set.index + 1)")
				.font(.subheadline.bold())
				.foregroundStyle(.secondary)
				.frame(width: 50, alignment: .leading)

			setTypeBadge(set.setType)

			Spacer()

			HStack(spacing: 16) {
				Text("\(set.formattedWeight) kg")
					.font(.subheadline.monospacedDigit())

				Text("×")
					.font(.caption)
					.foregroundStyle(.tertiary)

				Text("\(set.reps) reps")
					.font(.subheadline.monospacedDigit())
			}

			Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
				.foregroundStyle(set.isCompleted ? .green : .secondary)
				.imageScale(.medium)
		}
		.padding(.vertical, 4)
	}

	@ViewBuilder
	private func setTypeBadge(_ type: SetType) -> some View {
		let (title, color): (String, Color) = switch type {
		case .warmup: ("WARMUP", .orange)
		case .working: ("WORK", .blue)
		case .failure: ("FAILURE", .red)
		case .dropSet: ("DROP", .purple)
		}

		Text(title)
			.font(.caption2.bold())
			.padding(.horizontal, 6)
			.padding(.vertical, 2)
			.background(color.opacity(0.15))
			.foregroundStyle(color)
			.clipShape(Capsule())
	}
}

#Preview("Completed Set") {
	SetRowView(set: WorkoutSet(index: 0, weight: 100.0, reps: 8, setType: .working, isCompleted: true))
		.padding()
}

#Preview("Failure Set") {
	SetRowView(set: WorkoutSet(index: 2, weight: 105.0, reps: 6, setType: .failure, isCompleted: true))
		.padding()
}
