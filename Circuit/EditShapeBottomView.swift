//
//  EditShapeBottomView.swift
//  Circuit
//

import SwiftUI

struct EditShapeBottomView: View {
    var deleteAllCircles: () -> Void
    var addCircle: () -> Void
    var removeLastCircle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button("Delete All", action: deleteAllCircles)
                .customButtonStyle()
                .accessibilityIdentifier("DeleteAllButton")
                .accessibilityLabel("Delete all circles")
            Button("Add", action: addCircle)
                .customButtonStyle()
                .accessibilityIdentifier("AddButton")
                .accessibilityLabel("Add circle")
            Button("Remove", action: removeLastCircle)
                .customButtonStyle()
                .accessibilityIdentifier("RemoveButton")
                .accessibilityLabel("Remove last circle")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

    
    
    
