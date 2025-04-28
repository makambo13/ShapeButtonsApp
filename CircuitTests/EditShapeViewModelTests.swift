//
//  EditShapeViewModel.swift
//  CircuitTests
//
//  Created by Makambo Yemomo on 4/28/25.
//

import XCTest
@testable import Circuit

final class EditShapeViewModelTests: XCTestCase {
    var shapeViewModel: ShapeViewModel!
    var editViewModel: EditShapeViewModel!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        shapeViewModel = ShapeViewModel(shapeService: MockShapeService())
        editViewModel = EditShapeViewModel(shapeViewModel: shapeViewModel)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        shapeViewModel = nil
        editViewModel = nil
    }
    
    func testAddCircle() {
        editViewModel.addCircle()
        XCTAssertEqual(shapeViewModel.shapes, ["circle"])
        XCTAssertEqual(editViewModel.circles, ["circle"])
    }

    func testRemoveLastCircle() {
        shapeViewModel.shapes = ["circle", "square", "circle"]
        editViewModel.removeLastCircle()
        XCTAssertEqual(shapeViewModel.shapes, ["circle", "square"])
    }

    func testDeleteAllCircles() {
        shapeViewModel.shapes = ["circle", "square", "circle", "triangle"]
        editViewModel.deleteAllCircles()
        XCTAssertEqual(shapeViewModel.shapes, ["square", "triangle"])
    }
    // just want to see how adding 1000 circle performs
    func testPerformanceOfAddingCircles() {
        measure {
            for _ in 0..<1000 {
                editViewModel.addCircle()
            }
        }
    }
}
