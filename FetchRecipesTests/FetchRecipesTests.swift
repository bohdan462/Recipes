//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import Foundation
import UIKit
import Testing
@testable import FetchRecipes

// MARK: – Helper
private struct StubRepo: RecipeRepository {
    let stub: [Recipe]
    func recipes() async throws -> [Recipe] { stub }
}

private extension Recipe {
    static func make(name: String, cuisine: String = "Test") -> Self {
        Recipe(id: UUID(),
               cuisine: cuisine,
               name: name,
               photoUrlLarge: nil,
               photoUrlSmall: nil,
               sourceUrl: nil,
               youtubeUrl: nil)
    }
}

// MARK: – Test

struct FetchRecipesTests {
    
    // Image cache must be concurrency safe
    @Test
    func imageCache_threadSafety() async throws {
        let cache = ImageCacheManager()
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg")!
        
        try await withThrowingTaskGroup(of: UIImage.self) { group in
            for _ in 0..<100 {
                group.addTask { try await cache.image(for: url) }
            }
            for try await _ in group {}
        }
        
        #expect(true)
    }
    
    //Sorting by name is case insensitive
    @Test
    func viewModel_sortsNameAZ_caseInsensitive() async throws {
        let repo = StubRepo(stub: [.make(name: "banana"),
                                   .make(name: "Apple")])
        
        let vm = await RecipesListViewViewModel(
            fetchRecipes: .init(repository: repo),
            cache: ImageCacheManager()
        )
        
        await vm.reload()
        await #expect(vm.filtered.first?.name == "Apple")
    }
}
