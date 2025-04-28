//
//  EditShapePage.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/28/25.
//

import SwiftUI

struct EditShapePage: View {
    @StateObject var editViewModel: EditShapeViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    private func createCircleShape() -> some View {
        return Circle()
            .fill()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(editViewModel.circles.indices, id: \.self) { _ in
                        createCircleShape()
                    }
                }
                .padding()
            }
            EditShapeBottomView(
                deleteAllCircles: { editViewModel.deleteAllCircles() },
                addCircle: { editViewModel.addCircle() },
                removeLastCircle: { editViewModel.removeLastCircle() }
            )
        }.navigationTitle("Edit Circles")
    }
}
