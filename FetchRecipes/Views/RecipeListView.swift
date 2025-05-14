//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import SwiftUI

enum SortOptions: String, CaseIterable, Identifiable {
    case nameAZ = "Name A-Z"
    case cuisine = "Cuisine"
    
    var id: Self { self }
}


struct RecipeListView: View {
    @StateObject private var viewModel: RecipesListViewViewModel
    
    init(repository: RecipeRepository, cache: ImageCache) {
        _viewModel = .init(
            wrappedValue: RecipesListViewViewModel(
                fetchRecipes: .init(repository: repository),
                cache: cache)
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.filtered.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                        Text("No recipes")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.opacity)
                }
                
                List(viewModel.filtered) { recipe in
                    RecipeCell(recipe: recipe) {
                        try await viewModel.loadImage(for: recipe)
                    }
                }
                .listStyle(.plain)
                .opacity(viewModel.isLoading ? 0 : 1)
            }
            .refreshable { await viewModel.reload() }
            .searchable(text: $viewModel.searchText, prompt: "Search recipes")
            .scrollDismissesKeyboard(.interactively)
            .toolbar(content: {
                sortToolbar
            })
            .task { await viewModel.loadIfNeeded() }
            .navigationTitle("Recipes")
        }
    }
    
    @ToolbarContentBuilder
    private var sortToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                ForEach(SortOptions.allCases) { option in
                    Button {
                        viewModel.sort = option
                    } label: {
                        Label(option.rawValue,
                              systemImage: viewModel.sort == option ? "checkmark" : "")
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down.square")
            }
        }
    }
    
    
}
#Preview {
    RecipeListView(
        repository: MockRepo(),
        cache: ImageCacheManager()
    )
}
