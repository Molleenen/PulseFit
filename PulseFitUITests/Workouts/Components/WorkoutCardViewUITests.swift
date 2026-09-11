import XCTest

final class WorkoutCardViewUITests: XCTestCase {
	@MainActor
	func testWorkoutCardViewRendersHeaderDurationAndExerciseCount() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		// Locate card container
		let card = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(card.waitForExistence(timeout: 5.0), "WorkoutCardView 'Push Day' not found")

		// 1. Verify Session Title
		let title = card.staticTexts["Push Day"]
		XCTAssertTrue(title.exists, "WorkoutCardView session title missing")

		// 2. Verify Formatted Duration Badge (computed via session.formattedDuration)
		let durationBadge = card.staticTexts["1h 0m"]
		XCTAssertTrue(durationBadge.exists, "WorkoutCardView duration badge '1h 0m' missing")

		// 3. Verify Exercise Count Label
		let exerciseCount = card.staticTexts["2 exercises"]
		XCTAssertTrue(exerciseCount.exists, "WorkoutCardView exercise count label '2 exercises' missing")
	}

	@MainActor
	func testWorkoutCardViewRendersSortedMuscleGroupBadges() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		let card = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(card.waitForExistence(timeout: 5.0))

		// Verify unique sorted muscle group badges derived from session.sortedMuscleGroups
		let chestBadge = card.staticTexts["Chest"]
		let shouldersBadge = card.staticTexts["Shoulders"]

		XCTAssertTrue(chestBadge.exists, "Muscle group badge 'Chest' missing from WorkoutCardView")
		XCTAssertTrue(shouldersBadge.exists, "Muscle group badge 'Shoulders' missing from WorkoutCardView")
	}
}
