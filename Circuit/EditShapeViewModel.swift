//
//  EditShapeViewModel.swift
//  Circuit
//

import Foundation
import Observation

@MainActor
@Observable
final class EditShapeViewModel {
    @ObservationIgnored private let shapeViewModel: ShapeViewModel

    init(shapeViewModel: ShapeViewModel) {
        self.shapeViewModel = shapeViewModel
    }

    var circles: [String] {
        shapeViewModel.shapes(ofType: "circle")
    }

    func addCircle() {
        shapeViewModel.addShape("circle")
    }

    func removeLastCircle() {
        shapeViewModel.removeLastShape(ofType: "circle")
    }

    func deleteAllCircles() {
        shapeViewModel.removeAllShapes(ofType: "circle")
    }
}
