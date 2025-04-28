//
//  ContentView.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/27/25.
//

import SwiftUI


/*
 This is Page 1 of the assessement
 i have added urls to documentation that i used to build this page

 */

struct ContentView: View {
    @State private var isShowingEditPage = false
    @StateObject private var viewModel = ShapeViewModel(shapeService: ShapeService())
    
    /*
    https://developer.apple.com/documentation/swiftui/lazyvgrid
    Specify the number of columns 3
     GridItem  reprents a description of a row or a column in a lazy grid. in this case if we wanted to have 4 columns we will just
    add one more GridItem item in the array
    https://developer.apple.com/documentation/swiftui/griditem
    */
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationStack {
                 VStack {
                     TopStaticButton(
                        clearAction: { viewModel.clearShapes() },
                        editAction: { isShowingEditPage = true }
                     )
                     
                     ScrollView {
                         LazyVGrid(columns: columns, spacing: 20) {
                             ForEach(viewModel.shapes.indices, id: \.self) { index in
                                 shapeView(for: viewModel.shapes[index])
                                     .frame(width: 80, height: 80)
                             }
                         }
                         .padding()
                     }
                     
                     ButtonButtonView(
                        shapes: $viewModel.shapes,
                        dynamicButtons: viewModel.shapeModelData?.buttons ?? []
                     )
                 }
                 .onAppear {
                     viewModel.fetchShapes()
                 }
                 .navigationTitle("Shapes Grid")
                 .navigationDestination(isPresented: $isShowingEditPage) {
                     EditShapePage(editViewModel: EditShapeViewModel(shapeViewModel: viewModel))
                 }.padding()
             }
         }
}

// https://developer.apple.com/documentation/swiftui/shapes
@ViewBuilder
   func shapeView(for shape: String) -> some View {
       switch shape.lowercased() {
       case "circle":
           Circle().fill()
       case "square":
           Rectangle().fill()
       case "triangle":
           TriangleShape().fill()
       default:
           EmptyView()
       }
   }


// source: https://codingwithrashid.com/how-to-create-triangle-shape-in-swiftui/
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

#Preview {
    ContentView()
}
