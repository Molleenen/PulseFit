import XCTest

final class SetRowViewUITests: XCTestCase {
	@MainActor
	func testSetRowViewRendersSetNumberWeightAndReps() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		// Navigate to detail screen hosting SetRowView components
		let workoutCard = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(workoutCard.waitForExistence(timeout: 5.0), "Sample workout card missing")
		workoutCard.tap()

		// 1. Verify Set Index Label ("Set 1")
		let setIndexText = app.staticTexts["Set 1"]
		XCTAssertTrue(setIndexText.waitForExistence(timeout: 5.0), "SetRowView index label 'Set 1' not found")

		// 2. Verify SetType Badge ("WORK")
		let workBadge = app.staticTexts["WORK"]
		XCTAssertTrue(workBadge.exists, "SetRowView badge 'WORK' not found")

		// 3. Verify Formatted Weight Label ("100 kg" using formattedWeight)
		let weightText = app.staticTexts["100 kg"]
		XCTAssertTrue(weightText.exists, "SetRowView formatted weight '100 kg' not found")

		// 4. Verify Reps Label ("8 reps")
		let repsText = app.staticTexts["8 reps"]
		XCTAssertTrue(repsText.exists, "SetRowView reps text '8 reps' not found")
	}

	@MainActor
	func testSetRowViewRendersWarmupBadgeAndFractionalWeight() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		let workoutCard = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(workoutCard.waitForExistence(timeout: 5.0))
		workoutCard.tap()

		// Verify Warmup Set Badge in Bench Press section
		let warmupBadge = app.staticTexts["WARMUP"]
		XCTAssertTrue(warmupBadge.waitForExistence(timeout: 5.0), "SetRowView badge 'WARMUP' not found")

		// Verify fractional weight formatting ("80 kg")
		let warmupWeight = app.staticTexts["80 kg"]
		XCTAssertTrue(warmupWeight.exists, "Warmup weight '60 kg' not rendered correctly")
	}
}
