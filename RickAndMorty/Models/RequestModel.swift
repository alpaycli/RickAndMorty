//
//  RequestModel.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 18.11.23.
//

import Foundation

enum RequestHTTPMethod: Equatable {
    case get([URLQueryItem])
    case put(Data?)
    case post(Data?)
    case delete
    case head

    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}


struct Request<Response> {
    let url: URL
    let method: RequestHTTPMethod
    var headers: [String: String] = [:]
}

extension Request {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)

        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        case let .get(queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }

        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }
}

extension URLSession {
    func decode<Value: Decodable>(
        _ request: Request<Value>,
        using decoder: JSONDecoder = .init()
    ) async throws -> Value {
        let decoded = Task.detached(priority: .userInitiated) {
            return try await NetworkManager.shared.fetch(Value.self, url: request.urlRequest)
        }
        return try await decoded.value
    }
}

extension URLSession {
    func decode<Value: Decodable>(
        _ request: Request<Value>,
        using decoder: JSONDecoder = .init(),
        completion: @escaping(Result<Value, APIError>) -> Void
    ) {
        NetworkManager.shared.fetch(Value.self, urlRequest: request.urlRequest, completion: completion)
    }
}

// MARK: Example Uasge
// extension Request where Response == RMCharacterResponse { func getAllCharacters() { } }

extension Request where Response == RMCharacterResponse {
    static func getAllCharacters(forPage page: Int) -> Self {
        Request(
            url: URL(string: "https://rickandmortyapi.com/api/character")!,
            method: .get(
                [.init(name: "page", value: "\(page)")]
            )
        )
    }
}

extension Request where Response == RMLocationResponse {
    static func getAllLocations(forPage page: Int) -> Self {
        Request(
            url: URL(string: "https://rickandmortyapi.com/api/location")!,
            method: .get(
                [.init(name: "page", value: "\(page)")]
            )
        )
    }
}

extension Request where Response == RMEpisodeResponse {
    static func getAllEpisodes(forPage page: Int) -> Self {
        Request(
            url: URL(string: "https://rickandmortyapi.com/api/episode")!,
            method: .get(
                [.init(name: "page", value: "\(page)")]
            )
        )
    }
}
