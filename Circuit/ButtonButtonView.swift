//
//  ButtonButtonView.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/27/25.
//

import SwiftUI

struct ButtonButtonView: View {
    @Binding var shapes: [String]
    var dynamicButtons: [ShapeButton]

    var body: some View {
            HStack(spacing: 16) {
                ForEach(dynamicButtons, id: \.name) { button in
                    Button(button.name) {
                        shapes.append(button.draw_path)
                    }.customButtonStyle()
                        .accessibilityIdentifier(button.name)
                        .accessibilityLabel(button.name)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .padding()
    }
}

#Preview {
    ButtonButtonView(
        shapes: .constant([]), dynamicButtons:
            [
                ShapeButton(name: "Circle", draw_path: "circle"),
                ShapeButton(name: "Square", draw_path: "square"),
                ShapeButton(name: "Triangle", draw_path: "triangle")
            ]
    )
}

/*
 
 {
    "buttons":[
       {
          "name":"Circle",
          "draw_path":"circle"
       },
       {
          "name":"Square",
          "draw_path":"square"
       },
       {
          "name":"Triangle",
          "draw_path":"triangle"
       }
    ]
 }
 
 */
