import SwiftData
import SwiftUI

@main
struct PulseFitApp: App {
	/// The application-wide SwiftData container instance.
	let container: ModelContainer

	init() {
		do {
			let schema = Schema([
				WorkoutSession.self,
				ExerciseLog.self,
				WorkoutSet.self
			])
			let configuration = ModelConfiguration(schema: schema)
			container = try ModelContainer(for: schema, configurations: [configuration])
		} catch {
			fatalError("Failed to initialize SwiftData ModelContainer: \(error)")
		}
	}

	var body: some Scene {
		WindowGroup {
			MainTabView()
		}
		.modelContainer(container)
	}
}
