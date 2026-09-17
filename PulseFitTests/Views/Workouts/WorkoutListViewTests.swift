import Foundation
@testable import PulseFit
import SwiftData
import Testing

@Suite("WorkoutListView & SwiftData Integration Tests")
struct WorkoutListViewTests {
	@Test("Fetching workouts from in-memory ModelContainer returns populated sessions")
	@MainActor
	func fetchWorkoutsFromContainer() throws {
		let container = PreviewContainer.sample
		let context = container.mainContext

		let descriptor = FetchDescriptor<WorkoutSession>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
		let sessions = try context.fetch(descriptor)

		#expect(!sessions.isEmpty)
		let firstSession = try #require(sessions.first)
		#expect(firstSession.name == "Push Day")
		#expect(firstSession.exerciseLogs.count == 2)
	}

	@Test("Deleting a WorkoutSession cascades to child ExerciseLogs and WorkoutSets")
	@MainActor
	func deleteWorkoutSessionCascades() throws {
		// Initialize an isolated in-memory container for test mutations
		let schema = Schema([
			WorkoutSession.self,
			ExerciseLog.self,
			WorkoutSet.self
		])
		let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: schema, configurations: [config])
		let context = container.mainContext

		// Seed a session with 1 exercise log and 2 sets
		let session = WorkoutSession(name: "Test Leg Day", startDate: Date())
		let log = ExerciseLog(exerciseName: "Squat", muscleGroup: "Legs")
		let set1 = WorkoutSet(index: 0, weight: 100, reps: 5)
		let set2 = WorkoutSet(index: 1, weight: 120, reps: 3)

		log.sets = [set1, set2]
		session.exerciseLogs = [log]
		context.insert(session)
		try context.save()

		// Verify initial persistence
		let initialSessions = try context.fetch(FetchDescriptor<WorkoutSession>())
		#expect(initialSessions.count == 1)

		// Perform deletion
		context.delete(session)
		try context.save()

		// Assert cascade deletion across child entities
		let remainingSessions = try context.fetch(FetchDescriptor<WorkoutSession>())
		let remainingLogs = try context.fetch(FetchDescriptor<ExerciseLog>())
		let remainingSets = try context.fetch(FetchDescriptor<WorkoutSet>())

		#expect(remainingSessions.isEmpty)
		#expect(remainingLogs.isEmpty)
		#expect(remainingSets.isEmpty)
	}
}
