//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 14.11.23.
//

import Foundation

class NetworkManager {
    let baseURL: String = "https://rickandmortyapi.com/api/"
}

extension NetworkManager {
    // MARK: Generic Network Layer - Result type, completion handlers
    func fetch<T: Decodable>(_ type: T.Type, urlRequest: URLRequest?, completion: @escaping(Result<T, APIError>) -> Void) {
        
        guard let urlRequest else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error as? URLError {
                completion(.failure(APIError.url(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(APIError.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedItems = try decoder.decode(type, from: data)
                    completion(.success(decodedItems))
                } catch {
                    completion(.failure(APIError.parsing(error as? DecodingError)))
                }
            }
            
        }
        task.resume()
    }
}

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // for client
        switch self {
        case .badURL, .parsing, .unknown:
            return "Something went wrong"
        case .badResponse(_):
            return "Sorry, your connection lost with our server"
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
    
    var description: String {
        // for debugging
        switch self {
        case .badURL:
            return "Invalid URL"
        case .parsing(let error):
            return "parsing error: \(error?.localizedDescription ?? "")"
        case .badResponse(statusCode: let statusCode):
            return "Bad response with \(statusCode)"
        case .url(let error):
            return error?.localizedDescription ?? "url session over"
        case .unknown:
            return "Something went wrong"
        }
    }
}
