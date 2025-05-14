//
//  RecipesListViewViewModel.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import UIKit

@MainActor
class RecipesListViewViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var sort: SortOptions = .nameAZ
    @Published var searchText = ""
    
    fileprivate var sortedRecipes: [Recipe] {
        switch sort {
        case .nameAZ:
            recipes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .cuisine:
            recipes.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
        }
    }
    
    var filtered: [Recipe] {
        guard !searchText.isEmpty else { return sortedRecipes }
        return sortedRecipes.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private let fetchRecipes: FetchRecipesUseCase
    private let cache: ImageCache
    
    init(fetchRecipes: FetchRecipesUseCase, cache: ImageCache = ImageCacheManager()) {
        self.fetchRecipes = fetchRecipes
        self.cache = cache
    }
    
    func loadIfNeeded() async {
        guard recipes.isEmpty else { return }
        await load()
    }
    
    func reload() async { await load() }
    
    func loadImage(for recipe: Recipe) async throws -> UIImage? {
        guard let url = recipe.photoUrlSmall ?? recipe.photoUrlLarge else { return nil }
        
        do {
            let image = try await cache.image(for: url)
            return image
        } catch {
            return nil
        }
    }
    
    private func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            recipes = try await fetchRecipes.fetchRecipes()
        } catch {
            recipes = []
        }
    }
}
