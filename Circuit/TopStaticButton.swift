//
//  TopStaticButton.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/27/25.
//

import SwiftUI

struct TopStaticButton: View {
    var clearAction: () -> Void
    var editAction: () -> Void

    var body: some View {
        HStack {
            Button("Clear All", action: clearAction)
                .customButtonStyle()
                .accessibilityLabel("Clear all shapes")
                .frame(maxWidth: .infinity)
            Button("Edit Circles", action: editAction)
                .customButtonStyle()
                .accessibilityLabel("Edit circles view")
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
