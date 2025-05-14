//
//  APIEndpoint.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import Foundation

enum APIEndpoint {
    case recipes
    case malformedData
    case emptyData
    
    private var baseURL: URL {
        URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/")!
    }
    
    var url: URL {
        switch self {
        case .recipes:
            return baseURL.appendingPathComponent("recipes.json")
        case .malformedData:
            return baseURL.appendingPathComponent("recipes-empty.json")
        case .emptyData:
            return baseURL.appendingPathComponent("recipes-malformed.json")
        }
    }
}
