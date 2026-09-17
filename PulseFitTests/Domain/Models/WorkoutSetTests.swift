@testable import PulseFit
import Testing

@Suite("WorkoutSet Domain Tests")
struct WorkoutSetTests {
	// MARK: - Initializer & Default Values

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

	// MARK: - Formatting & Presentation Extension Tests

	@Test("formattedWeight strips decimal zero for whole numbers")
	func formatWholeWeightNumber() {
		let set = WorkoutSet(index: 0, weight: 100.0, reps: 8, setType: .working)
		#expect(set.formattedWeight == "100")
	}

	@Test("formattedWeight preserves decimal place for fractional values")
	func formatDecimalWeightNumber() {
		let set = WorkoutSet(index: 0, weight: 102.5, reps: 5, setType: .working)
		#expect(set.formattedWeight == "102.5")
	}
}
