//
//  ShapeService.swift
//  Circuit
//

import Foundation

protocol ShapeServiceProtocol: Sendable {
    func getShapes() async throws(ShapeServiceError) -> ShapeModel
}

enum ShapeServiceError: Error {
    case networkError(any Error)
    case badStatus(Int)
    case decodingError(any Error)
}

struct ShapeService: ShapeServiceProtocol {

    // A hard-coded URL that is always valid, so the force unwrap is safe here.
    private let shapesURL = URL(string: "http://staticcontent.cricut.com/static/test/shapes_001.json")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func buildRequest() -> URLRequest {
        var request = URLRequest(url: shapesURL)
        request.httpMethod = "GET"
        return request
    }

    func getShapes() async throws(ShapeServiceError) -> ShapeModel {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: buildRequest())
        } catch {
            throw .networkError(error)
        }

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw .badStatus(http.statusCode)
        }

        // The feed has trailing commas, which the JSON5 spec allows. Accepting JSON5 is simpler and safer than
        // rewriting the text with a regular expression. ShapeServiceTests covers this on the oldest iOS we support.
        let decoder = JSONDecoder()
        decoder.allowsJSON5 = true
        do {
            return try decoder.decode(ShapeModel.self, from: data)
        } catch {
            throw .decodingError(error)
        }
    }
}
