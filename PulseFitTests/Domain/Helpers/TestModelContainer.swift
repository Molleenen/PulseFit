@testable import PulseFit
import SwiftData

@MainActor
enum TestModelContainer {
	static func create() throws -> ModelContainer {
		let schema = Schema([
			WorkoutSession.self,
			ExerciseLog.self,
			WorkoutSet.self
		])
		let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
		return try ModelContainer(for: schema, configurations: [configuration])
	}
}
