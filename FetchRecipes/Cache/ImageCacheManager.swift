//
//  ImageCacheManager.swift
//  FetchRecipes
//
//  Created by Bohdan Tkachenko on 5/7/25.
//

import UIKit
import CryptoKit

protocol ImageCache {
    func image(for url: URL) async throws -> UIImage
    
}

actor ImageCacheManager: ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private let diskCacheUrl: URL
    private let io = DispatchQueue(label: "ImageDiskIO")
    
    init() {
        let fileManager = FileManager.default
        let cacheDirectoryUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheUrl = cacheDirectoryUrl.appendingPathComponent("recipeImages")
        
        if !fileManager.fileExists(atPath: diskCacheUrl.path) {
            try? fileManager.createDirectory(at: diskCacheUrl, withIntermediateDirectories: true)
        }
        
        cache.countLimit = 100
    }
    
    func image(for url: URL) async throws -> UIImage {
        let key = url.absoluteString as NSString
        if let hit = cache.object(forKey: key) { return hit }
        
        let file = diskCacheUrl.appendingPathComponent(url.absoluteString.sha256())
        
        // read disk on background queue
        if let img = try await readDisk(file) {
            cache.setObject(img, forKey: key)
            return img
        }
        
        // fetch
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let img = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
        cache.setObject(img, forKey: key)
        try await writeDisk(data, to: file)
        return img
    }
    
    // MARK: – Helpers
    private func readDisk(_ url: URL) async throws -> UIImage? {
        try await withCheckedThrowingContinuation { cont in
            io.async {
                if let data = try? Data(contentsOf: url),
                   let img  = UIImage(data: data) {
                    cont.resume(returning: img)
                } else { cont.resume(returning: nil) }
            }
        }
    }
    
    private func writeDisk(_ data: Data, to url: URL) async throws {
        try await withCheckedThrowingContinuation { cont in
            io.async {
                do    { try data.write(to: url); cont.resume() }
                catch { cont.resume(throwing: error) }
            }
        }
    }
    
}

private extension String {
    func sha256() -> String {
        let data = Data(self.utf8)
        let hashData = SHA256.hash(data: data)
        return hashData.map {
            String(format:"%02x", $0)
        }.joined()
    }
}
