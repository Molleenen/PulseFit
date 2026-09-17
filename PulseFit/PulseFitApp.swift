import SwiftData
import SwiftUI

@main
struct PulseFitApp: App {
	let container: ModelContainer

	init() {
		if ProcessInfo.processInfo.arguments.contains("-enable-test-seed") {
			// Use in-memory sample container during UI test execution
			container = PreviewContainer.sample
		} else {
			// Standard production container
			do {
				container = try ModelContainer(for: WorkoutSession.self)
			} catch {
				fatalError("Failed to initialize production ModelContainer: \(error)")
			}
		}
	}

	var body: some Scene {
		WindowGroup {
			MainTabView()
		}
		.modelContainer(container)
	}
}
