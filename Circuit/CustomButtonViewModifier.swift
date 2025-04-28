//
//  CustomButtonViewModifier.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/27/25.
//

import Foundation
import SwiftUI

//https://developer.apple.com/documentation/swiftui/viewmodifier
struct CustomButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .frame(width: 100, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}

extension View {
    func customButtonStyle() -> some View {
        self.modifier(CustomButtonStyle())
    }
}

