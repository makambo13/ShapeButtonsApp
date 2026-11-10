//
//  TopStaticButton.swift
//  Circuit
//

import SwiftUI

struct TopStaticButton: View {
    var clearAction: () -> Void
    var editAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button("Clear All", action: clearAction)
                .customButtonStyle()
                .accessibilityLabel("Clear all shapes")
            Button("Edit Circles", action: editAction)
                .customButtonStyle()
                .accessibilityLabel("Edit circles view")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
