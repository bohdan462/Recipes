//
//  RecipeCell.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/6/25.
//

import SwiftUI
import SafariServices

struct RecipeCell: View {
    private enum Phase {
        case loading, success(UIImage), failed
    }
    
    let recipe: Recipe
    let imageLoader: () async throws -> UIImage?
    
    @State private var phase: Phase = .loading
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                imageView
                VStack(alignment: .leading, spacing: 2) {
                    
                    Text("\(recipe.name)").bold()
                    Text("Cuisine: \(recipe.cuisine)").font(.footnote).foregroundStyle(.secondary)
                }
            }
            HStack {
                if let youtubeUrl = recipe.youtubeUrl {
                    
                    Button {
                        openWebpage(url: youtubeUrl)
                    } label: {
                        Label("Watch Video", systemImage: "play.square.fill")
                    }
                    .buttonStyle(.bordered)
                    
                }
                if let sourceUrl = recipe.sourceUrl {
                    Button {
                        openWebpage(url: sourceUrl)
                    } label: {
                        Label("View Recipe", systemImage: "eye.square.fill")
                        
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .task(id: recipe.id) {
            await loadImage()
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        switch phase {
        case .loading:
            ProgressView()
        case .failed:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        case .success(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .accessibilityLabel(Text(recipe.name))
        }
    }
    
    private func loadImage() async {
        do {
            if let image = try await imageLoader() { phase = .success(image)}
            else { phase = .failed }
        } catch {
            
        }
    }
    
    private func openWebpage(url: URL) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(SFSafariViewController(url: url), animated: true)
        }
    }
}

#Preview {
    RecipeCell(recipe: Recipe(id: UUID(), cuisine: "British", name: "Apple Pie", photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg")!, photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg")!, sourceUrl: URL(string: "https://www.bbcgoodfood.com/recipes/banana-pancakes")!, youtubeUrl: URL(string: "https://www.youtube.com/watch?v=kSKtb2Sv-_U")!)) { return UIImage(named: "background")}
}
