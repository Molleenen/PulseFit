import XCTest

final class WorkoutListViewUITests: XCTestCase {
	@MainActor
	func testWorkoutListViewDisplaysEmptyStateWhenNoSessionsExist() {
		let app = XCUIApplication()
		// Launch without test seed argument to test clean empty state
		app.launch()

		let emptyTitle = app.staticTexts["No Workouts Yet"]
		XCTAssertTrue(emptyTitle.waitForExistence(timeout: 5.0), "Empty state title missing on clean app launch")
	}

	@MainActor
	func testWorkoutListViewDisplaysNavigationTitleAndSeededSections() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		// 1. Verify Root Navigation Title
		let navBar = app.navigationBars["Workouts"]
		XCTAssertTrue(navBar.waitForExistence(timeout: 5.0), "Workouts root navigation bar title missing")

		// 2. Verify Add Workout '+' Toolbar Button Exists
		let addButton = navBar.buttons.firstMatch
		XCTAssertTrue(addButton.exists, "Plus button missing from Workouts toolbar")

		// 3. Verify Date Grouping Section Headers Render
		// (Based on PreviewContainer sample data dates)
		let todaySection = app.staticTexts["Today"]
		let earlierSection = app.staticTexts["Earlier"]

		XCTAssertTrue(todaySection.waitForExistence(timeout: 5.0) || earlierSection.exists, "No date section headers rendered in WorkoutListView")

		// 4. Verify Seeded Workout Card Rows Exist
		let hyperCard = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(hyperCard.exists, "Seeded card 'Push Day' missing from list")
	}

	@MainActor
	func testWorkoutListViewSupportsScrollAndCardSelection() {
		let app = XCUIApplication()
		app.launchArguments = ["-enable-test-seed"]
		app.launch()
		app.activate()

		let workoutList = app.tables.firstMatch.exists ? app.tables.firstMatch : app.collectionViews.firstMatch
		XCTAssertTrue(workoutList.waitForExistence(timeout: 5.0), "Workout list view collection missing")

		// Verify first card is hittable and interactive
		let firstCard = app.buttons.containing(.staticText, identifier: "Push Day").firstMatch
		XCTAssertTrue(firstCard.isHittable, "Workout list card item is not tappable")
	}
}
