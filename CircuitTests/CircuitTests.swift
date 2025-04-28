//
//  CircuitTests.swift
//  CircuitTests
//
//  Created by Makambo Yemomo on 4/27/25.
//

import XCTest
@testable import Circuit

class MockShapeService: ShapeServiceProtocol {
    func getShapes(completion: @escaping (Result<ShapeModel, any Error>) -> Void) {
        completion(.success(ShapeModel(buttons: [])))
    }
}

final class CircuitTests: XCTestCase {
    var shapeViewModel: ShapeViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        shapeViewModel = ShapeViewModel(shapeService: MockShapeService())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        shapeViewModel =  nil
    }
    
    func testAddShape() {
        shapeViewModel.addShape("circle")
        XCTAssertEqual(shapeViewModel.shapes.count, 1)
        XCTAssertEqual(shapeViewModel.shapes.first, "circle")
    }
    
    func testClearShapes() {
        shapeViewModel.addShape("circle")
        shapeViewModel.clearShapes()
        XCTAssertEqual(shapeViewModel.shapes.count, 0)
    }
    
    func testFetchShapesLoadsData() {
        shapeViewModel.fetchShapes()
        XCTAssertNotNil(shapeViewModel.shapeModelData)
    }
}
