//
//  EditShapePage.swift
//  Circuit
//

import SwiftUI

struct EditShapePage: View {
    @State private var editViewModel: EditShapeViewModel

    init(shapeViewModel: ShapeViewModel) {
        _editViewModel = State(initialValue: EditShapeViewModel(shapeViewModel: shapeViewModel))
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    private func createCircleShape() -> some View {
        return Circle()
            .fill()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 100)
            .accessibilityIdentifier("EditCircle")
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(editViewModel.circles.enumerated()), id: \.offset) { _, _ in
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
