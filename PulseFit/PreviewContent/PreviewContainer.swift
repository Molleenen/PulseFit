import Foundation
import SwiftData
import SwiftUI

/// An in-memory SwiftData container initialized with realistic sample data for SwiftUI Previews and testing.
@MainActor
enum PreviewContainer {
	/// A shared, pre-populated in-memory `ModelContainer` ready for `#Preview` injection.
	static let sample: ModelContainer = {
		do {
			let schema = Schema([
				WorkoutSession.self,
				ExerciseLog.self,
				WorkoutSet.self
			])
			let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
			let container = try ModelContainer(for: schema, configurations: [config])
			let context = container.mainContext

			// Seed Sample Data
			let pushSession = WorkoutSession(
				name: "Push Day",
				startDate: Date().addingTimeInterval(-3_600),
				endDate: Date(),
				notes: "Felt strong on bench press today. New PR on last set."
			)

			let benchPress = ExerciseLog(
				exerciseName: "Barbell Bench Press",
				muscleGroup: "Chest",
				notes: "Pause at bottom on every rep"
			)

			let benchSet1 = WorkoutSet(index: 0, weight: 80.0, reps: 10, setType: .warmup, isCompleted: true)
			let benchSet2 = WorkoutSet(index: 1, weight: 100.0, reps: 8, setType: .working, isCompleted: true)
			let benchSet3 = WorkoutSet(index: 2, weight: 105.0, reps: 6, setType: .failure, isCompleted: true)

			benchPress.sets = [benchSet1, benchSet2, benchSet3]

			let overheadPress = ExerciseLog(
				exerciseName: "Overhead Barbell Press",
				muscleGroup: "Shoulders",
				notes: "Keep core tight"
			)

			let ohpSet1 = WorkoutSet(index: 0, weight: 50.0, reps: 8, setType: .working, isCompleted: true)
			let ohpSet2 = WorkoutSet(index: 1, weight: 55.0, reps: 6, setType: .working, isCompleted: false)

			overheadPress.sets = [ohpSet1, ohpSet2]

			pushSession.exerciseLogs = [benchPress, overheadPress]
			context.insert(pushSession)

			return container
		} catch {
			fatalError("Failed to initialize preview ModelContainer: \(error)")
		}
	}()
}
