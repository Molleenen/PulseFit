import XCTest

final class WorkoutDetailViewUITests: XCTestCase {
	@MainActor
	func testWorkoutDetailViewDisplaysSummaryAndExerciseSections() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		// 1. Navigate to WorkoutDetailView via card tap
		let workoutCard = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(workoutCard.waitForExistence(timeout: 5.0), "Sample workout card missing")
		workoutCard.tap()

		// 2. Verify Navigation Bar Title
		let detailNavBar = app.navigationBars["Push Day"]
		XCTAssertTrue(detailNavBar.waitForExistence(timeout: 5.0), "Detail view navigation bar title missing")

		// 3. Verify Summary Section Items
		let summaryHeader = app.staticTexts["Summary"]
		XCTAssertTrue(summaryHeader.exists, "Summary section header missing")

		let durationLabel = app.staticTexts["1h 0m"]
		XCTAssertTrue(durationLabel.exists, "Formatted duration missing from detail summary")

		// 4. Verify Exercise Section Headers
		let benchPressHeader = app.staticTexts["Barbell Bench Press"]
		let overheadPressHeader = app.staticTexts["Overhead Barbell Press"]

		XCTAssertTrue(benchPressHeader.waitForExistence(timeout: 5.0), "Exercise header 'Barbell Bench Press' missing")
		XCTAssertTrue(overheadPressHeader.exists, "Exercise header 'Overhead Dumbbell Press' missing")

		// 5. Verify Muscle Group Labels in Section Headers
		let chestGroup = app.staticTexts["Chest"]
		let shouldersGroup = app.staticTexts["Shoulders"]

		XCTAssertTrue(chestGroup.exists, "Muscle group tag 'Chest' missing from exercise section")
		XCTAssertTrue(shouldersGroup.exists, "Muscle group tag 'Shoulders' missing from exercise section")
	}

	@MainActor
	func testWorkoutDetailViewPopsBackToWorkoutsList() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		// Navigate in
		let workoutCard = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(workoutCard.waitForExistence(timeout: 5.0))
		workoutCard.tap()

		// Verify inside detail
		XCTAssertTrue(app.navigationBars["Push Day"].waitForExistence(timeout: 5.0))

		// Tap Back button
		let backButton = app.navigationBars.buttons.firstMatch
		XCTAssertTrue(backButton.exists, "Navigation back button missing")
		backButton.tap()

		// Verify returned to Workouts root list
		XCTAssertTrue(app.navigationBars["Workouts"].waitForExistence(timeout: 5.0), "Failed to pop back to root Workouts list")
	}
}
