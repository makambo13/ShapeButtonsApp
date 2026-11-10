//
//  TestDoubles.swift
//  CircuitTests
//

import Foundation
@testable import Circuit

struct MockShapeService: ShapeServiceProtocol {
    var result: Result<ShapeModel, ShapeServiceError> = .success(ShapeModel(buttons: []))

    func getShapes() async throws(ShapeServiceError) -> ShapeModel {
        try result.get()
    }
}

/// Counts calls and can fail the first N of them.
actor CountingShapeService: ShapeServiceProtocol {
    private(set) var calls = 0
    private var failuresLeft: Int
    private let model: ShapeModel

    init(failFirst: Int = 0, model: ShapeModel) {
        self.failuresLeft = failFirst
        self.model = model
    }

    func getShapes() async throws(ShapeServiceError) -> ShapeModel {
        calls += 1
        if failuresLeft > 0 {
            failuresLeft -= 1
            throw .badStatus(500)
        }
        return model
    }
}

/// Answers every request the app's URLSession makes, so no test touches the network.
final class StubURLProtocol: URLProtocol {
    nonisolated(unsafe) static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
