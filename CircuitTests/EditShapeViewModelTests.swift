//
//  EditShapeViewModelTests.swift
//  CircuitTests
//

import XCTest
@testable import Circuit

@MainActor
final class EditShapeViewModelTests: XCTestCase {
    private var shapeViewModel: ShapeViewModel!
    private var editViewModel: EditShapeViewModel!

    override func setUp() async throws {
        try await super.setUp()
        shapeViewModel = ShapeViewModel(shapeService: MockShapeService())
        editViewModel = EditShapeViewModel(shapeViewModel: shapeViewModel)
    }

    override func tearDown() async throws {
        shapeViewModel = nil
        editViewModel = nil
        try await super.tearDown()
    }

    func testAddCircle() {
        editViewModel.addCircle()
        XCTAssertEqual(shapeViewModel.shapes, ["circle"])
        XCTAssertEqual(editViewModel.circles, ["circle"])
    }

    func testRemoveLastCircleLeavesOtherShapes() {
        ["circle", "square", "circle"].forEach(shapeViewModel.addShape)
        editViewModel.removeLastCircle()
        XCTAssertEqual(shapeViewModel.shapes, ["circle", "square"])
    }

    func testDeleteAllCirclesKeepsOtherShapes() {
        ["circle", "square", "circle", "triangle"].forEach(shapeViewModel.addShape)
        editViewModel.deleteAllCircles()
        XCTAssertEqual(shapeViewModel.shapes, ["square", "triangle"])
        XCTAssertTrue(editViewModel.circles.isEmpty)
    }

    func testCirclesOnlyListsCircles() {
        ["square", "circle", "triangle", "circle"].forEach(shapeViewModel.addShape)
        XCTAssertEqual(editViewModel.circles.count, 2)
    }

    func testPerformanceOfAddingCircles() {
        measure {
            for _ in 0..<1000 { editViewModel.addCircle() }
            editViewModel.deleteAllCircles()
        }
    }
}
