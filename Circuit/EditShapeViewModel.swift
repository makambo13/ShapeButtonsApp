//
//  EditShapeViewModel.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/28/25.
//

import Foundation

class EditShapeViewModel: ObservableObject {
    private var shapeViewModel: ShapeViewModel
    
    init(shapeViewModel: ShapeViewModel) {
        self.shapeViewModel = shapeViewModel
    }
    
    var circles: [String] {
        shapeViewModel.shapes.filter { $0 == "circle" }
    }
    
    func addCircle() {
        shapeViewModel.addShape("circle")
    }
    
    func removeLastCircle() {
        if let lastCircleIndex = shapeViewModel.shapes.lastIndex(of: "circle") {
            shapeViewModel.shapes.remove(at: lastCircleIndex)
        }
    }
    
    func deleteAllCircles() {
        shapeViewModel.shapes.removeAll(where: { $0 == "circle" })
    }
}
