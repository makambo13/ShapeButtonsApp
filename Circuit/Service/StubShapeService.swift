//
//  StubShapeService.swift
//  Circuit
//

import Foundation

#if DEBUG
/// Canned feeds so UI tests do not depend on the network. Chosen with a launch argument.
struct StubShapeService: ShapeServiceProtocol {
    enum Mode { case threeButtons, manyButtons, failing }
    let mode: Mode

    func getShapes() async throws(ShapeServiceError) -> ShapeModel {
        switch mode {
        case .threeButtons:
            return ShapeModel(buttons: Self.basics)
        case .manyButtons:
            let extra = (1...5).map { ShapeButton(name: "Extra \($0)", draw_path: "circle") }
            return ShapeModel(buttons: Self.basics + extra)
        case .failing:
            throw .badStatus(503)
        }
    }

    private static let basics = [
        ShapeButton(name: "Circle", draw_path: "circle"),
        ShapeButton(name: "Square", draw_path: "square"),
        ShapeButton(name: "Triangle", draw_path: "triangle"),
    ]
}
#endif

enum AppEnvironment {
    static func makeShapeService() -> ShapeServiceProtocol {
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-UITestFailFeed") { return StubShapeService(mode: .failing) }
        if arguments.contains("-UITestManyButtons") { return StubShapeService(mode: .manyButtons) }
        if arguments.contains("-UITestStubFeed") { return StubShapeService(mode: .threeButtons) }
        #endif
        return ShapeService()
    }
}
