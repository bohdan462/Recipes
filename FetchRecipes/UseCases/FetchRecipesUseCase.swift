//
//  FetchRecipesUseCase.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/13/25.
//

import Foundation

struct FetchRecipesUseCase {
    private let repository: RecipeRepository
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    func fetchRecipes() async throws -> [Recipe] {
        return try await repository.recipes()
    }
}
