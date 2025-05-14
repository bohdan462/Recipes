//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    private let cache = ImageCacheManager()
    private let repository = RemoteRecipeRepository()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(repository: repository, cache: cache)
        }
    }
}
