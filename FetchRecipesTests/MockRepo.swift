//
//  MockrRepo.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/14/25.
//

import Foundation

struct MockRepo: RecipeRepository {
    func recipes() async throws -> [Recipe] {
           [Recipe(
               id: UUID(), cuisine: "British", name: "Apple Pie",
               photoUrlLarge: nil, photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg"),
               sourceUrl: nil, youtubeUrl: nil)]
       }
}
