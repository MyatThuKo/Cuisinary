//
//  RecipeService.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import UIKit
import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

protocol RecipeServiceProtocol {
    func fetchRecipeData(endPoint: API.Endpoint) async throws -> [Recipe]
    func loadImage(from url: URL) async -> UIImage?
}

enum RecipeServiceError: Error, Equatable {
    case emptyData
    case malformedData
    case networkError(Error)
    case invalidURL
    
    static func == (lhs: RecipeServiceError, rhs: RecipeServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.emptyData, .emptyData),
            (.malformedData, .malformedData),
            (.invalidURL, .invalidURL):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

final class RecipeService: RecipeServiceProtocol {
    static let shared = RecipeService()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func fetchRecipeData(endPoint: API.Endpoint) async throws -> [Recipe] {
        guard let url = URL(string: endPoint.urlString) else {
            throw RecipeServiceError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        do {
            let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return recipeResponse.recipes
        } catch {
            throw RecipeServiceError.malformedData
        }
    }

    func loadImage(from url: URL) async -> UIImage? {
        let urlString = url.absoluteString as NSString

        if let cachedImage = cache.object(forKey: urlString) {
            return cachedImage
        }

        let cachedURL = getCachedImageURL(for: url)
        if let diskCachedImage = UIImage(contentsOfFile: cachedURL.path) {
            cache.setObject(diskCachedImage, forKey: urlString)
            return diskCachedImage
        }

        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            guard let downloadedImage = UIImage(data: data) else {
                return nil
            }

            cache.setObject(downloadedImage, forKey: urlString)
            try data.write(to: cachedURL)
            return downloadedImage
        } catch {
            print("Failed to load or cache image: \(error.localizedDescription)")
            return nil
        }
    }

    private func getCachedImageURL(for url: URL) -> URL {
        let fileManager = FileManager.default
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let hashedFileName = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? url.lastPathComponent
        return cacheDir.appendingPathComponent(hashedFileName)
    }
}

