import XCTest

final class MainTabViewUITests: XCTestCase {
	@MainActor
	func testTabSwitching() {
		let app = XCUIApplication()
		app.launch()

		// 1. Ensure the app is frontmost in headless CI environments
		app.activate()

		let workoutsTab = app.tabBars.buttons["Workouts"]
		let analyticsTab = app.tabBars.buttons["Analytics"]

		// 2. Wait for initial UI stabilization
		XCTAssertTrue(workoutsTab.waitForExistence(timeout: 5.0), "Workouts tab did not appear in time")
		XCTAssertTrue(workoutsTab.isSelected, "Workouts tab should be selected by default")
		XCTAssertFalse(analyticsTab.isSelected, "Analytics tab should not be selected initially")

		// 3. Perform tap
		analyticsTab.tap()

		// 4. Wait explicitly for the selection state transition (renamed variable to avoid shadowing)
		let analyticsSelectedPredicate = NSPredicate(format: "isSelected == true")
		let analyticsExpectation = expectation(for: analyticsSelectedPredicate, evaluatedWith: analyticsTab)

		let waiterResult = XCTWaiter.wait(for: [analyticsExpectation], timeout: 5.0)
		XCTAssertEqual(waiterResult, .completed, "Analytics tab failed to transition to selected state within timeout")

		XCTAssertFalse(workoutsTab.isSelected, "Workouts tab should no longer be selected")
		XCTAssertTrue(app.navigationBars["Analytics"].waitForExistence(timeout: 5.0))

		// 5. Switch back
		workoutsTab.tap()

		let workoutsSelectedPredicate = NSPredicate(format: "isSelected == true")
		let workoutsExpectation = expectation(for: workoutsSelectedPredicate, evaluatedWith: workoutsTab)

		let returnResult = XCTWaiter.wait(for: [workoutsExpectation], timeout: 5.0)
		XCTAssertEqual(returnResult, .completed, "Workouts tab failed to return to selected state within timeout")
	}
}
