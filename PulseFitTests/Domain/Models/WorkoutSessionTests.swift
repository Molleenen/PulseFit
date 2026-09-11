import Foundation
@testable import PulseFit
import SwiftData
import Testing

@Suite("WorkoutSession Domain Tests")
struct WorkoutSessionTests {
	// MARK: - Initializer & Defaults

	@Test("WorkoutSession initializes with expected defaults")
	func initializationDefaults() {
		let before = Date()
		let session = WorkoutSession(name: "Morning Lift")
		let after = Date()

		#expect(session.name == "Morning Lift")
		#expect(session.endDate == nil)
		#expect(session.exerciseLogs.isEmpty)
		#expect(session.startDate >= before && session.startDate <= after)
	}

	@Test("WorkoutSession duration defaults to nil when session is active")
	func durationDefault() {
		let session = WorkoutSession(name: "Push day")

		#expect(session.name == "Push day")
		#expect(session.endDate == nil)
		#expect(session.exerciseLogs.isEmpty)
		#expect(session.duration == nil)
	}

	// MARK: - Business Logic

	@Test("Calculates completed duration correctly")
	func durationCalculation() {
		let start = Date()
		let end = start.addingTimeInterval(3_600)
		let session = WorkoutSession(name: "Leg Day", startDate: start, endDate: end)

		#expect(session.duration == 3_600)
	}

	// MARK: - Persistence & Cascade

	@Test("Deleting session cascade deletes child logs and sets")
	@MainActor
	func cascadeDelete() throws {
		let container = try TestModelContainer.create()
		let context = container.mainContext

		let session = WorkoutSession(name: "Hypertrophy Push")
		let exercise = ExerciseLog(exerciseName: "Bench Press")
		let set = WorkoutSet(index: 0, weight: 80.0, reps: 8)

		exercise.sets = [set]
		session.exerciseLogs = [exercise]

		context.insert(session)
		try context.save()

		context.delete(session)
		try context.save()

		#expect(try context.fetch(FetchDescriptor<WorkoutSession>()).isEmpty)
		#expect(try context.fetch(FetchDescriptor<ExerciseLog>()).isEmpty)
		#expect(try context.fetch(FetchDescriptor<WorkoutSet>()).isEmpty)
	}

	// MARK: - Formatting & Presentation Extension Tests

	@Test("sortedMuscleGroups extracts unique sorted muscle groups")
	func extractUniqueSortedMuscleGroups() {
		let session = WorkoutSession(name: "Full Body")
		let log1 = ExerciseLog(exerciseName: "Bench Press", muscleGroup: "Chest")
		let log2 = ExerciseLog(exerciseName: "Incline Press", muscleGroup: "Chest")
		let log3 = ExerciseLog(exerciseName: "Squat", muscleGroup: "Legs")

		session.exerciseLogs = [log1, log2, log3]

		#expect(session.sortedMuscleGroups == ["Chest", "Legs"])
	}

	@Test("formattedDuration displays hours and minutes when duration exceeds 1 hour")
	func formatSessionDurationHoursAndMinutes() {
		let startDate = Date()
		let endDate = startDate.addingTimeInterval(4_500) // 75 minutes
		let session = WorkoutSession(name: "Push Day", startDate: startDate, endDate: endDate)

		#expect(session.formattedDuration == "1h 15m")
	}

	@Test("formattedDuration displays 'In Progress' when duration is nil")
	func formatSessionDurationNil() {
		let session = WorkoutSession(name: "Active Session", startDate: Date(), endDate: nil)

		#expect(session.formattedDuration == "In Progress")
	}
}
