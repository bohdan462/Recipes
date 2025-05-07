//
//  RecipeCell.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import SwiftUI
import SafariServices

struct RecipeCell: View {
    let recipe: Recipe
    let imageHandler: (Recipe) async throws -> UIImage?
    
    @State private var image: UIImage?
    
    var body: some View {
        HStack {
            if let url = recipe.photoUrlSmall {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .clipShape(Rectangle())
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                    
                }
            }
            VStack(alignment: .leading) {
            
                    Text("\(recipe.name)")
                    Text("Cuisine: \(recipe.cuisine)")
              
                HStack {
                    if let youtubeUrl = recipe.youtubeUrl {
                        Button {
                            openWebpage(url: youtubeUrl)
                        } label: {
                            Label("Watch Video", systemImage: "play.square.fill")
                        }

                    }
                    
                    if let sourceUrl = recipe.sourceUrl {
                        Button {
                            openWebpage(url: sourceUrl)
                        } label: {
                            Label("View Recipe", systemImage: "eye.square.fill")
                        }

                    }
                }
            }
        }
    }
    
    private func openWebpage(url: URL) {
        let savariVC = SFSafariViewController(url: url)
        UIApplication.shared.windows.first?.rootViewController?.present(savariVC, animated: true)
    }
}

#Preview {
    RecipeCell(recipe: Recipe(id: UUID(), cuisine: "British", name: "Apple Pie", photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg")!, photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg")!, sourceUrl: URL(string: "https://www.bbcgoodfood.com/recipes/banana-pancakes")!, youtubeUrl: URL(string: "https://www.youtube.com/watch?v=kSKtb2Sv-_U")!)) {_ in return UIImage(named: "background")}
}
