//
//  EditShapeBottomView.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/28/25.
//

import SwiftUI

struct EditShapeBottomView: View {
    var deleteAllCircles: () -> Void
    var addCircle: () -> Void
    var removeLastCircle: () -> Void
    
    var body: some View {
        HStack {
            Button("Delete All", action: deleteAllCircles)
                .customButtonStyle()
                .accessibilityIdentifier("DeleteAllButton")
                .accessibilityLabel("Delete all circles")
            Spacer()
            Button("Add", action: addCircle)
                .customButtonStyle()
                .accessibilityIdentifier("AddButton")
                .accessibilityLabel("Add circle")
            Spacer()
            Button("Remove", action: removeLastCircle)
                .customButtonStyle()
                .accessibilityIdentifier("RemoveButton")
                .accessibilityLabel("Remove last circle")
        }.padding()
    }
}

    
    
    
