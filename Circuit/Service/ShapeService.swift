//
//  ShapeService.swift
//  Circuit
//
//  Created by Makambo Yemomo on 4/28/25.
//

import Foundation

protocol ShapeServiceProtocol {
    func getShapes(completion: @escaping(Result<ShapeModel, Error>) -> Void)
}

enum ShapeServiceError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
}

class ShapeService: ShapeServiceProtocol {
    
    //You can use ! when you are using hard code url that's always going to exist
    private  let shapesURL = URL(string: "http://staticcontent.cricut.com/static/test/shapes_001.json")!
    
    func buildRequest () -> URLRequest {
        var request = URLRequest(url: shapesURL)
        request.httpMethod = "GET"
        return request
    }
    
    func getShapes(completion: @escaping (Result<ShapeModel, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: buildRequest()) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(ShapeServiceError.networkError(error)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                completion(.failure(ShapeServiceError.noData))
                }
                return
            }
            
            do {
                guard var jsonString = String(data: data, encoding: .utf8) else {
                    DispatchQueue.main.async {
                        completion(.failure(ShapeServiceError.noData))
                    }
                    return
                }
                jsonString = jsonString.replacingOccurrences(of: ",\\s*([}\\]])", with: "$1", options: .regularExpression)
                guard let cleanData = jsonString.data(using: .utf8) else {
                    DispatchQueue.main.async {
                        completion(.failure(ShapeServiceError.noData))
                    }
                    return
                }
                let shapeModel = try JSONDecoder().decode(ShapeModel.self, from: cleanData)
                DispatchQueue.main.async {
                    completion(.success(shapeModel))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(ShapeServiceError.decodingError(error)))
                }
            }
        }
        task.resume()
    }
}

