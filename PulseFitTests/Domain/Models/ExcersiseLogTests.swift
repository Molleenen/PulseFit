import Foundation
@testable import PulseFit
import SwiftData
import Testing

@Suite("ExerciseLog Domain Tests")
struct ExerciseLogTests {
	// MARK: - Initializer & Default Values

	@Test("ExerciseLog initializes with expected defaults and empty sets")
	func initializationDefaults() {
		let exercise = ExerciseLog(exerciseName: "Barbell Bench Press")

		#expect(exercise.exerciseName == "Barbell Bench Press")
		#expect(exercise.muscleGroup == nil)
		#expect(exercise.notes == nil)
		#expect(exercise.sets.isEmpty)
		#expect(exercise.workoutSession == nil)
	}

	@Test("ExerciseLog correctly stores optional muscle group and notes")
	func initializationWithOptionals() {
		let exercise = ExerciseLog(
			exerciseName: "Squat",
			muscleGroup: "Quadriceps",
			notes: "Focused on depth and control"
		)

		#expect(exercise.exerciseName == "Squat")
		#expect(exercise.muscleGroup == "Quadriceps")
		#expect(exercise.notes == "Focused on depth and control")
	}

	// MARK: - Set Association & Order Logic

	@Test("Adding WorkoutSets preserves set collection ordering")
	func setAssociation() {
		let exercise = ExerciseLog(exerciseName: "Overhead Press")
		let warmupSet = WorkoutSet(index: 0, weight: 40.0, reps: 10, setType: .warmup)
		let workingSet = WorkoutSet(index: 1, weight: 60.0, reps: 5, setType: .working)

		exercise.sets = [warmupSet, workingSet]

		#expect(exercise.sets.count == 2)
		#expect(exercise.sets[0].setType == .warmup)
		#expect(exercise.sets[1].setType == .working)
		#expect(exercise.sets[0].index == 0)
		#expect(exercise.sets[1].index == 1)
	}

	// MARK: - Persistence & Cascade Deletion

	@Test("Deleting ExerciseLog cascade deletes its child WorkoutSets")
	@MainActor
	func cascadeDelete() throws {
		let container = try TestModelContainer.create()
		let context = container.mainContext

		let exercise = ExerciseLog(exerciseName: "Incline Dumbbell Press")
		let set1 = WorkoutSet(index: 0, weight: 30.0, reps: 10)
		let set2 = WorkoutSet(index: 1, weight: 32.0, reps: 8)

		exercise.sets = [set1, set2]

		context.insert(exercise)
		try context.save()

		// Verify initial persistence
		let initialLogs = try context.fetch(FetchDescriptor<ExerciseLog>())
		let initialSets = try context.fetch(FetchDescriptor<WorkoutSet>())
		#expect(initialLogs.count == 1)
		#expect(initialSets.count == 2)

		// When: Deleting exercise log
		context.delete(exercise)
		try context.save()

		// Then: Child sets should be purged automatically
		let remainingLogs = try context.fetch(FetchDescriptor<ExerciseLog>())
		let remainingSets = try context.fetch(FetchDescriptor<WorkoutSet>())

		#expect(remainingLogs.isEmpty)
		#expect(remainingSets.isEmpty)
	}
}
