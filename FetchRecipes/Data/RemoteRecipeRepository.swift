//
//  RemoteRecipeRepository.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/13/25.
//

import Foundation

protocol RecipeRepository {
    func recipes() async throws -> [Recipe]
}

final class RemoteRecipeRepository: RecipeRepository {
    private let client: APIClient
    
    init(client: APIClient = .init()) {
        self.client = client
    }
    
    func recipes() async throws -> [Recipe] {
        let response = try await client.request(endpoint: .recipes, method: .get, response: RecipeResponse.self)
        return response.recipes
    }
}
