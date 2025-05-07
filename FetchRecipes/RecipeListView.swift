//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject var viewModel: RecipesListViewViewModel
    
    init() {
       _viewModel = StateObject(wrappedValue: RecipesListViewViewModel())
        
    }
    
    var body: some View {
        List(viewModel.fetchedRecipes) {
            RecipeCell(recipe: $0) {
                try await viewModel.loadImage(for: $0)
            }
        }
        .task {
            do {
                try await viewModel.fetchRecipes()
            } catch {
                print("Errro fetching recipes in the view: \(error)")
            }
        }
    }
}

#Preview {
    RecipeListView()
}
