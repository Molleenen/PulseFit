import XCTest

final class MainTabViewUITests: XCTestCase {
	@MainActor
	func testTabSwitching() {
		let app = XCUIApplication()
		app.launch()

		let workoutsTab = app.tabBars.buttons["Workouts"]
		let analyticsTab = app.tabBars.buttons["Analytics"]

		// 1. Verify "Workouts" tab is selected by default
		XCTAssertTrue(workoutsTab.exists)
		XCTAssertTrue(workoutsTab.isSelected, "Workouts tab should be selected by default")
		XCTAssertFalse(analyticsTab.isSelected, "Analytics tab should not be selected initially")
		XCTAssertTrue(app.navigationBars["Workouts"].exists)

		// 2. Switch to Analytics tab
		XCTAssertTrue(analyticsTab.exists)
		analyticsTab.tap()

		// 3. Verify selection state flipped and title updated
		XCTAssertTrue(analyticsTab.isSelected, "Analytics tab should be selected after tapping")
		XCTAssertFalse(workoutsTab.isSelected, "Workouts tab should no longer be selected")
		XCTAssertTrue(app.navigationBars["Analytics"].exists)

		// 4. Switch back to Workouts tab
		workoutsTab.tap()
		XCTAssertTrue(workoutsTab.isSelected, "Workouts tab should be selected after tapping back")
	}
}
