//
//  ShapeServiceTests.swift
//  CircuitTests
//

import XCTest
@testable import Circuit

final class ShapeServiceTests: XCTestCase {
    /// The real feed has trailing commas inside the array and the objects.
    private let feedWithTrailingCommas = """
    {
       "buttons":[
          { "name":"Circle", "draw_path":"circle", },
          { "name":"Square", "draw_path":"square", },
          { "name":"Triangle", "draw_path":"triangle", },
       ]
    }
    """

    private func makeService() -> ShapeService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return ShapeService(session: URLSession(configuration: configuration))
    }

    private func respond(status: Int, body: String) {
        StubURLProtocol.handler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!, Data(body.utf8))
        }
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    func testDecodesFeedWithTrailingCommas() async throws {
        respond(status: 200, body: feedWithTrailingCommas)
        let model = try await makeService().getShapes()
        XCTAssertEqual(model.buttons.map(\.name), ["Circle", "Square", "Triangle"])
        XCTAssertEqual(model.buttons.map(\.draw_path), ["circle", "square", "triangle"])
    }

    func testDecodesCleanJSONToo() async throws {
        respond(status: 200, body: #"{"buttons":[{"name":"Circle","draw_path":"circle"}]}"#)
        let model = try await makeService().getShapes()
        XCTAssertEqual(model.buttons.count, 1)
    }

    func testSendsAGetToTheFeedURL() async throws {
        nonisolated(unsafe) var captured: URLRequest?
        StubURLProtocol.handler = { request in
            captured = request
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, Data(#"{"buttons":[]}"#.utf8))
        }
        _ = try await makeService().getShapes()
        XCTAssertEqual(captured?.httpMethod, "GET")
        XCTAssertEqual(captured?.url?.absoluteString, "http://staticcontent.cricut.com/static/test/shapes_001.json")
    }

    func testServerErrorIsReportedAsBadStatusNotADecodeFailure() async {
        respond(status: 500, body: "<html>Internal Server Error</html>")
        do {
            _ = try await makeService().getShapes()
            XCTFail("Expected an error")
        } catch {
            guard case .badStatus(let code) = error else { return XCTFail("Wrong error: \(error)") }
            XCTAssertEqual(code, 500)
        }
    }

    func testMalformedJSONIsADecodingError() async {
        respond(status: 200, body: "not json at all")
        do {
            _ = try await makeService().getShapes()
            XCTFail("Expected an error")
        } catch {
            guard case .decodingError = error else { return XCTFail("Wrong error: \(error)") }
        }
    }

    func testWrongShapeOfJSONIsADecodingError() async {
        respond(status: 200, body: #"{"shapes":[]}"#)
        do {
            _ = try await makeService().getShapes()
            XCTFail("Expected an error")
        } catch {
            guard case .decodingError = error else { return XCTFail("Wrong error: \(error)") }
        }
    }

    func testTransportFailureIsANetworkError() async {
        StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }
        do {
            _ = try await makeService().getShapes()
            XCTFail("Expected an error")
        } catch {
            guard case .networkError(let underlying) = error else { return XCTFail("Wrong error: \(error)") }
            XCTAssertEqual((underlying as? URLError)?.code, .notConnectedToInternet)
        }
    }
}
