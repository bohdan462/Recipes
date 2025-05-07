//
//  RecipesListViewViewModel.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import UIKit

class RecipesListViewViewModel: ObservableObject {
    
    private let client: APIClient
    
   @Published var fetchedRecipes: [Recipe] = []
    
    init(apiClient: APIClient = NetworkActor()) {
        client = apiClient
    }
    
    func fetchRecipes() async throws {
        let response = try await client.request(endpoint: .recipes, method: .get, response: RecipeResponse.self)
        fetchedRecipes = response.recipes
    }
    
    func loadImage(for recipe: Recipe) async throws -> UIImage? {
        guard let url = recipe.photoUrlSmall else { return nil }
       let (data,_) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
}
