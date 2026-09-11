@testable import PulseFit
import SwiftData
import Testing

@Suite("PreviewContainer Integration Tests")
struct PreviewContainerTests {
	@Test("PreviewContainer initializes without throwing and populates sample data")
	@MainActor
	func sampleContainerInitialization() throws {
		let container = PreviewContainer.sample
		let context = container.mainContext

		let sessions = try context.fetch(FetchDescriptor<WorkoutSession>())
		let logs = try context.fetch(FetchDescriptor<ExerciseLog>())
		let sets = try context.fetch(FetchDescriptor<WorkoutSet>())

		#expect(!sessions.isEmpty)
		#expect(!logs.isEmpty)
		#expect(!sets.isEmpty)

		// Verify seeded relationships match expected counts
		let firstSession = try #require(sessions.first)
		#expect(firstSession.exerciseLogs.count == 2)
	}
}
