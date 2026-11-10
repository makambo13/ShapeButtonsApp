//
//  ShapeViewModel.swift
//  Circuit
//

import Foundation
import Observation

@MainActor
@Observable
final class ShapeViewModel {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @ObservationIgnored private let shapeService: ShapeServiceProtocol

    private(set) var shapeModelData: ShapeModel?
    private(set) var shapes: [String] = []
    private(set) var loadState: LoadState = .idle

    var buttons: [ShapeButton] { shapeModelData?.buttons ?? [] }

    init(shapeService: ShapeServiceProtocol) {
        self.shapeService = shapeService
    }

    /// Loads the button list once. Safe to call again from `.task`, which runs every time the view appears.
    func fetchShapes() async {
        switch loadState {
        case .loading, .loaded: return
        case .idle, .failed: break
        }
        loadState = .loading
        do {
            shapeModelData = try await shapeService.getShapes()
            loadState = .loaded
        } catch {
            // `.task` cancels the work when the view goes away. That is not a failure, so allow a later retry.
            loadState = Task.isCancelled ? .idle : .failed(Self.message(for: error))
        }
    }

    func addShape(_ type: String) {
        shapes.append(type)
    }

    func clearShapes() {
        shapes.removeAll()
    }

    func shapes(ofType type: String) -> [String] {
        shapes.filter { $0 == type }
    }

    func removeLastShape(ofType type: String) {
        if let index = shapes.lastIndex(of: type) {
            shapes.remove(at: index)
        }
    }

    func removeAllShapes(ofType type: String) {
        shapes.removeAll { $0 == type }
    }

    private static func message(for error: ShapeServiceError) -> String {
        switch error {
        case .networkError:
            return "Couldn't reach the server. Check your connection and try again."
        case .badStatus(let code):
            return "The server returned an error (\(code)). Try again in a moment."
        case .decodingError:
            return "The shape list wasn't in the format the app expected."
        }
    }
}
