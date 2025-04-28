//
//  ShapeViewModel.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/27/25.
//

import Foundation

class ShapeViewModel: ObservableObject {
    let shapeService: ShapeServiceProtocol
    @Published var shapeModelData : ShapeModel?
    @Published var shapes = [String]()
    
    init(shapeService: ShapeServiceProtocol) {
        self.shapeService = shapeService
    }
    
    func fetchShapes() {
        shapeService.getShapes { result in
            switch result {
            case .success(let shapeModel):
                self.shapeModelData = shapeModel
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func addShape(_ type: String) {
        shapes.append(type)
    }
    
    func clearShapes() {
        shapes.removeAll()
    }
}
