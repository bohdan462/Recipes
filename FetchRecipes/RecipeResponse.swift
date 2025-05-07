//
//  RecipeResponse.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import Foundation

struct RecipeResponse: Decodable {
    let recipes: [Recipe]
}
