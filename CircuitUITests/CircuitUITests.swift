//
//  CircuitUITests.swift
//  CircuitUITests
//

import XCTest

final class CircuitUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    @MainActor
    override func tearDown() async throws {
        // continueAfterFailure is false, so a failed landscape test would otherwise leave the simulator rotated.
        XCUIDevice.shared.orientation = .portrait
        try await super.tearDown()
    }

    // MARK: - Helpers

    /// Launches the app on a canned feed so these tests never depend on the network.
    @MainActor
    private func launchApp(_ extraArguments: String...) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += extraArguments.isEmpty ? ["-UITestStubFeed"] : extraArguments
        app.launch()
        return app
    }

    @MainActor
    private func count(_ app: XCUIApplication, _ identifier: String) -> Int {
        app.descendants(matching: .any).matching(identifier: identifier).count
    }

    @MainActor
    private func snapshot(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    // MARK: - Behaviour

    @MainActor
    func testFeedButtonsAppearAndTappingAddsShapes() throws {
        let app = launchApp()

        let circle = app.buttons["Circle"]
        XCTAssertTrue(circle.waitForExistence(timeout: 10), "Buttons never appeared")
        XCTAssertTrue(app.buttons["Square"].exists)
        XCTAssertTrue(app.buttons["Triangle"].exists)
        snapshot(app, "1 buttons loaded")

        circle.tap()
        app.buttons["Square"].tap()
        app.buttons["Triangle"].tap()
        app.buttons["Circle"].tap()
        XCTAssertEqual(count(app, "GridShape"), 4)
        snapshot(app, "2 four shapes added")

        app.buttons["Clear all shapes"].tap()
        XCTAssertEqual(count(app, "GridShape"), 0)
        snapshot(app, "3 cleared")
    }

    @MainActor
    func testEditCirclesPageAddRemoveDelete() throws {
        let app = launchApp()
        XCTAssertTrue(app.buttons["Circle"].waitForExistence(timeout: 10))

        app.buttons["Circle"].tap()
        app.buttons["Circle"].tap()
        app.buttons["Square"].tap()
        XCTAssertEqual(count(app, "GridShape"), 3)

        app.buttons["Edit circles view"].tap()
        XCTAssertTrue(app.buttons["AddButton"].waitForExistence(timeout: 5))
        XCTAssertEqual(count(app, "EditCircle"), 2)

        app.buttons["AddButton"].tap()
        XCTAssertEqual(count(app, "EditCircle"), 3)
        snapshot(app, "4 edit page, 3 circles")

        app.buttons["RemoveButton"].tap()
        XCTAssertEqual(count(app, "EditCircle"), 2)

        app.buttons["DeleteAllButton"].tap()
        XCTAssertEqual(count(app, "EditCircle"), 0)
        snapshot(app, "5 edit page, circles deleted")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.buttons["Circle"].waitForExistence(timeout: 5))
        XCTAssertEqual(count(app, "GridShape"), 1, "Only the square should be left on the main grid")
    }

    @MainActor
    func testButtonsAreTappableAwayFromTheirLabel() throws {
        let app = launchApp()
        let circle = app.buttons["Circle"]
        XCTAssertTrue(circle.waitForExistence(timeout: 10))

        // Tap near the left edge of the blue area, nowhere near the text in the middle.
        circle.coordinate(withNormalizedOffset: CGVector(dx: 0.04, dy: 0.5)).tap()
        XCTAssertEqual(count(app, "GridShape"), 1, "The whole button should respond, not only its label")
    }

    @MainActor
    func testFeedFailureShowsMessageAndRetry() throws {
        let app = launchApp("-UITestFailFeed")

        XCTAssertTrue(app.staticTexts["LoadErrorMessage"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["LoadErrorMessage"].label.contains("503"))
        XCTAssertFalse(app.buttons["Circle"].exists)
        snapshot(app, "error state")

        app.buttons["RetryButton"].tap()
        XCTAssertTrue(app.staticTexts["LoadErrorMessage"].waitForExistence(timeout: 10), "Still failing, so the message stays")
    }

    @MainActor
    func testManyButtonsScrollInsteadOfOverflowing() throws {
        let app = launchApp("-UITestManyButtons")
        let circle = app.buttons["Circle"]
        XCTAssertTrue(circle.waitForExistence(timeout: 10))
        XCTAssertTrue(app.windows.firstMatch.frame.contains(circle.frame))

        circle.swipeLeft()
        let last = app.buttons["Extra 5"]
        XCTAssertTrue(last.isHittable, "The last button should be reachable by scrolling")
        last.tap()
        XCTAssertEqual(count(app, "GridShape"), 1)
        snapshot(app, "many buttons, scrolled")
    }

    // MARK: - Layout

    /// Every control must sit fully inside the screen, and neighbours in a row must not overlap.
    @MainActor
    private func assertMainScreenFits(_ app: XCUIApplication, _ label: String) {
        let screen = app.windows.firstMatch.frame
        let names = ["Clear all shapes", "Edit circles view", "Circle", "Square", "Triangle"]
        for name in names {
            let frame = app.buttons[name].frame
            XCTAssertTrue(screen.contains(frame), "\(label): '\(name)' \(frame) is outside the screen \(screen)")
            XCTAssertGreaterThanOrEqual(frame.minX, 8, "\(label): '\(name)' is hugging the left edge")
            XCTAssertLessThanOrEqual(frame.maxX, screen.maxX - 8, "\(label): '\(name)' is hugging the right edge")
        }
        let row = ["Circle", "Square", "Triangle"].map { app.buttons[$0].frame }
        XCTAssertLessThanOrEqual(row[0].maxX, row[1].minX, "\(label): Circle overlaps Square")
        XCTAssertLessThanOrEqual(row[1].maxX, row[2].minX, "\(label): Square overlaps Triangle")
        XCTAssertLessThanOrEqual(app.buttons["Clear all shapes"].frame.maxX, app.buttons["Edit circles view"].frame.minX)
    }

    @MainActor
    func testMainScreenFitsInPortraitAndLandscape() throws {
        let app = launchApp()
        XCTAssertTrue(app.buttons["Circle"].waitForExistence(timeout: 10))
        XCUIDevice.shared.orientation = .portrait
        for _ in 0..<7 { app.buttons["Circle"].tap() }
        assertMainScreenFits(app, "portrait")
        snapshot(app, "layout portrait")

        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertTrue(app.buttons["Circle"].waitForExistence(timeout: 5))
        assertMainScreenFits(app, "landscape")
        snapshot(app, "layout landscape")
    }

    @MainActor
    func testLargeAccessibilityTextKeepsButtonsReachable() throws {
        let app = launchApp("-UITestStubFeed", "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXL")
        let circle = app.buttons["Circle"]
        XCTAssertTrue(circle.waitForExistence(timeout: 10))
        XCTAssertTrue(app.windows.firstMatch.frame.contains(circle.frame), "The first button must be on screen")
        XCTAssertTrue(app.buttons["Triangle"].exists, "No button may be dropped at large text sizes")

        // If the row no longer fits it scrolls, so the last button must be reachable.
        if !app.buttons["Triangle"].isHittable { circle.swipeLeft() }
        XCTAssertTrue(app.buttons["Triangle"].isHittable)
        snapshot(app, "layout large text")
    }

    @MainActor
    func testEditScreenFits() throws {
        let app = launchApp()
        XCTAssertTrue(app.buttons["Circle"].waitForExistence(timeout: 10))
        for _ in 0..<5 { app.buttons["Circle"].tap() }
        app.buttons["Edit circles view"].tap()
        XCTAssertTrue(app.buttons["AddButton"].waitForExistence(timeout: 5))
        let screen = app.windows.firstMatch.frame
        let row = ["DeleteAllButton", "AddButton", "RemoveButton"].map { app.buttons[$0].frame }
        for (index, frame) in row.enumerated() {
            XCTAssertTrue(screen.contains(frame), "edit button \(index) is outside the screen")
            XCTAssertGreaterThanOrEqual(frame.minX, 8)
            XCTAssertLessThanOrEqual(frame.maxX, screen.maxX - 8)
        }
        XCTAssertLessThanOrEqual(row[0].maxX, row[1].minX)
        XCTAssertLessThanOrEqual(row[1].maxX, row[2].minX)
        snapshot(app, "layout edit page")
    }

    // MARK: - Launch

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let app = XCUIApplication()
            app.launchArguments += ["-UITestStubFeed"]
            app.launch()
        }
    }
}
