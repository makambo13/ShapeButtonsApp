//
//  CircuitTests.swift
//  CircuitTests
//

import XCTest
@testable import Circuit

@MainActor
final class CircuitTests: XCTestCase {
    private let threeButtons = ShapeModel(buttons: [
        ShapeButton(name: "Circle", draw_path: "circle"),
        ShapeButton(name: "Square", draw_path: "square"),
        ShapeButton(name: "Triangle", draw_path: "triangle"),
    ])

    func testAddShape() {
        let viewModel = ShapeViewModel(shapeService: MockShapeService())
        viewModel.addShape("circle")
        XCTAssertEqual(viewModel.shapes, ["circle"])
    }

    func testClearShapes() {
        let viewModel = ShapeViewModel(shapeService: MockShapeService())
        viewModel.addShape("circle")
        viewModel.clearShapes()
        XCTAssertTrue(viewModel.shapes.isEmpty)
    }

    func testFetchShapesLoadsButtons() async {
        let viewModel = ShapeViewModel(shapeService: MockShapeService(result: .success(threeButtons)))
        XCTAssertEqual(viewModel.loadState, .idle)
        await viewModel.fetchShapes()
        XCTAssertEqual(viewModel.loadState, .loaded)
        XCTAssertEqual(viewModel.buttons.map(\.name), ["Circle", "Square", "Triangle"])
    }

    func testFetchFailureShowsMessageAndNoButtons() async {
        let viewModel = ShapeViewModel(shapeService: MockShapeService(result: .failure(.badStatus(503))))
        await viewModel.fetchShapes()
        guard case .failed(let message) = viewModel.loadState else {
            return XCTFail("Expected a failed state, got \(viewModel.loadState)")
        }
        XCTAssertTrue(message.contains("503"))
        XCTAssertTrue(viewModel.buttons.isEmpty)
    }

    func testRetryAfterFailureLoads() async {
        let service = CountingShapeService(failFirst: 1, model: threeButtons)
        let viewModel = ShapeViewModel(shapeService: service)
        await viewModel.fetchShapes()
        XCTAssertNotEqual(viewModel.loadState, .loaded)
        await viewModel.fetchShapes()
        XCTAssertEqual(viewModel.loadState, .loaded)
        let calls = await service.calls
        XCTAssertEqual(calls, 2)
    }

    func testFetchDoesNotRepeatOnceLoaded() async {
        let service = CountingShapeService(model: threeButtons)
        let viewModel = ShapeViewModel(shapeService: service)
        await viewModel.fetchShapes()
        await viewModel.fetchShapes()
        let calls = await service.calls
        XCTAssertEqual(calls, 1)
    }

    func testShapesOfTypeAndRemoval() {
        let viewModel = ShapeViewModel(shapeService: MockShapeService())
        ["circle", "square", "circle", "triangle"].forEach(viewModel.addShape)
        XCTAssertEqual(viewModel.shapes(ofType: "circle").count, 2)
        viewModel.removeLastShape(ofType: "circle")
        XCTAssertEqual(viewModel.shapes, ["circle", "square", "triangle"])
        viewModel.removeAllShapes(ofType: "circle")
        XCTAssertEqual(viewModel.shapes, ["square", "triangle"])
        viewModel.removeLastShape(ofType: "circle")
        XCTAssertEqual(viewModel.shapes, ["square", "triangle"], "Removing a type that isn't there changes nothing")
    }
}
