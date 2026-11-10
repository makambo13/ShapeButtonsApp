//
//  ButtonButtonView.swift
//  Circuit
//

import SwiftUI

struct ButtonButtonView: View {
    var buttons: [ShapeButton]
    var onSelect: (ShapeButton) -> Void

    var body: some View {
        // https://developer.apple.com/documentation/swiftui/viewthatfits
        // Use the full-width row when it fits, otherwise let it scroll (many buttons or very large text).
        ViewThatFits(in: .horizontal) {
            row
            ScrollView(.horizontal, showsIndicators: false) {
                row
            }
        }
    }

    private var row: some View {
        HStack(spacing: 12) {
            // Offsets as ids, because the feed could repeat a name.
            ForEach(Array(buttons.enumerated()), id: \.offset) { _, button in
                Button(button.name) {
                    onSelect(button)
                }
                .customButtonStyle()
                .accessibilityIdentifier(button.name)
                .accessibilityLabel(button.name)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    ButtonButtonView(
        buttons: [
            ShapeButton(name: "Circle", draw_path: "circle"),
            ShapeButton(name: "Square", draw_path: "square"),
            ShapeButton(name: "Triangle", draw_path: "triangle")
        ],
        onSelect: { _ in }
    )
}
