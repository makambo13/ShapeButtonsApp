//
//  ContentView.swift
//  Circuit
//

import SwiftUI


/*
 This is Page 1 of the assessement
 i have added urls to documentation that i used to build this page

 */

struct ContentView: View {
    @State private var isShowingEditPage = false
    @State private var viewModel: ShapeViewModel

    init(shapeService: ShapeServiceProtocol = AppEnvironment.makeShapeService()) {
        _viewModel = State(initialValue: ShapeViewModel(shapeService: shapeService))
    }

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
                        // Iterate the values, not the indices: looking up viewModel.shapes[index] inside the
                        // closure crashes when the array shrinks (Clear All) before SwiftUI re-evaluates.
                        ForEach(Array(viewModel.shapes.enumerated()), id: \.offset) { _, shape in
                            shapeView(for: shape)
                                .frame(width: 80, height: 80)
                                .accessibilityIdentifier("GridShape")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }

                footer
            }
            // Starts when the view appears and is cancelled when it goes away; fetchShapes() copes with both.
            .task { await viewModel.fetchShapes() }
            .navigationTitle("Shapes Grid")
            .navigationDestination(isPresented: $isShowingEditPage) {
                EditShapePage(shapeViewModel: viewModel)
            }
        }
    }

    @ViewBuilder
    private var footer: some View {
        switch viewModel.loadState {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, minHeight: 66)
        case .failed(let message):
            LoadErrorView(message: message, retry: {
                Task { await viewModel.fetchShapes() }
            })
        case .loaded:
            ButtonButtonView(
                buttons: viewModel.buttons,
                onSelect: { viewModel.addShape($0.draw_path) }
            )
        }
    }
}

/// Shown instead of the buttons when the feed can't be loaded.
struct LoadErrorView: View {
    var message: String
    var retry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("LoadErrorMessage")
            Button("Try Again", action: retry)
                .customButtonStyle()
                .frame(maxWidth: 200)
                .accessibilityIdentifier("RetryButton")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
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
