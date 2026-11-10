//
//  CustomButtonViewModifier.swift
//  Circuit
//

import SwiftUI

// https://developer.apple.com/documentation/swiftui/buttonstyle
struct ShapeButtonStyle: ButtonStyle {
    private let corner = RoundedRectangle(cornerRadius: 15)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.medium))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 50)
            .foregroundStyle(.white)
            .background(Color.blue.opacity(configuration.isPressed ? 0.7 : 1), in: corner)
            .contentShape(corner)
    }
}

extension View {
    func customButtonStyle() -> some View {
        buttonStyle(ShapeButtonStyle())
    }
}
