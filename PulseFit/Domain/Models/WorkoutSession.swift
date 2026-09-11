import Foundation
import SwiftData

/// Top-level entity representing a complete workout event recorded by the user.
///
/// `WorkoutSession` maintains session timing metadata, overall workout notes, and a relational collection
/// of performed ``ExerciseLog`` entries.
///
/// - Important: Serves as the root anchor for workout cascades. Deleting a session purges the entire tree
///   (`WorkoutSession` ➔ `ExerciseLog` ➔ `WorkoutSet`).
@Model
final class WorkoutSession {
	/// Unique persistent identifier for the workout session.
	@Attribute(.unique) var id: UUID

	/// Custom title or name assigned to the workout (e.g., "Push Day A", "Upper Body Hypertrophy").
	var name: String

	/// Timestamp marking the commencement of the session.
	var startDate: Date

	/// Timestamp marking the completion of the session. `nil` indicates an active, ongoing workout.
	var endDate: Date?

	/// Optional post-workout summary or contextual notes.
	var notes: String?

	/// Collection of exercise entries recorded during this session.
	///
	/// - Note: Configured with `.cascade` deletion. Deleting a `WorkoutSession` automatically removes
	///   all child ``ExerciseLog`` objects and their cascading ``WorkoutSet`` children.
	@Relationship(deleteRule: .cascade, inverse: \ExerciseLog.workoutSession)
	var exerciseLogs: [ExerciseLog]

	/// Computed total elapsed duration of the workout session in seconds.
	///
	/// Returns `nil` if the session is currently active (`endDate` is `nil`).
	var duration: TimeInterval? {
		guard let endDate else { return nil }
		return endDate.timeIntervalSince(startDate)
	}

	/// Creates a new `WorkoutSession` instance.
	///
	/// - Parameters:
	///   - id: Unique identifier. Defaults to a new `UUID()`.
	///   - name: Session title.
	///   - startDate: Commencement timestamp. Defaults to current date/time.
	///   - endDate: Completion timestamp. Defaults to `nil`.
	///   - notes: Session summary notes. Optional.
	///   - exerciseLogs: Initial collection of logged exercises. Defaults to empty array.
	init(
		id: UUID = UUID(),
		name: String,
		startDate: Date = Date(),
		endDate: Date? = nil,
		notes: String? = nil,
		exerciseLogs: [ExerciseLog] = []
	) {
		self.id = id
		self.name = name
		self.startDate = startDate
		self.endDate = endDate
		self.notes = notes
		self.exerciseLogs = exerciseLogs
	}
}
