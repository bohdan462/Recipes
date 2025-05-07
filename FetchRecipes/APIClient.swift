//
//  APIClient.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case badResponse
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .badResponse:
            return "Bad Response"
        case .decodingFailed(let error):
            return "Decoding Failed With Error: \(error)"
        }
    }
}

enum HTTPMethod: String {
    case get
}

protocol APIClient {
    func request<T: Decodable>(endpoint: APIEndpoint, method: HTTPMethod, response: T.Type) async throws -> T where T: Decodable
}

extension APIClient {
    func createUrlRequest(endpoint: APIEndpoint, method: HTTPMethod) -> URLRequest {
        let url = endpoint.url
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    func request<T: Decodable>(endpoint: APIEndpoint, method: HTTPMethod, response: T.Type) async throws -> T {
       let request = createUrlRequest(endpoint: endpoint, method: method)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}

// Using Actor to keep async in a queu of tasks 
actor NetworkActor: APIClient {
    static let shared = NetworkActor()
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}
