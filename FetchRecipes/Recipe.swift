//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import Foundation

struct Recipe: Identifiable, Hashable, Decodable {
    let id: UUID
    let cuisine: String
    let name: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let youtubeUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
