@testable import PulseFit
import Testing

@Suite("WorkoutSet Domain Tests")
struct WorkoutSetTests {
	@Test("WorkoutSet initializes with default working set type and uncompleted state")
	func setDefaults() {
		let set = WorkoutSet(index: 0, weight: 100.0, reps: 5)

		#expect(set.setType == .working)
		#expect(set.isCompleted == false)
	}

	@Test("Unrecognized SetType raw value falls back safely to .working")
	func setTypeFallback() {
		let set = WorkoutSet(index: 0, weight: 100.0, reps: 5)
		set.setTypeRawValue = "CorruptedOrFutureValue"

		#expect(set.setType == .working)
	}
}
