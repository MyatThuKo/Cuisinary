//
//  MockRecipeService.swift
//  DishDiscoveryTests
//
//  Created by Myat Thu Ko on 10/13/24.
//

import Foundation
import UIKit

@testable import Cuisinary

final class MockRecipeService: RecipeServiceProtocol {
    enum TestCase {
        case malformedData
        case emptyData
        case validData([Recipe])
    }
    
    private let testCase: TestCase
    private var inMemoryCache = [String: UIImage]() // Mock for NSCache
    private let fileManager = FileManager.default
    private let diskCacheURL: URL

    init(testCase: TestCase) {
        self.testCase = testCase

        // Use a temporary directory for the mock disk cache
        let tempDirectory = NSTemporaryDirectory()
        self.diskCacheURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent("MockImageCache", isDirectory: true)

        // Create the directory if it doesn't exist
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }

    func fetchRecipeData(endPoint: API.Endpoint) async throws -> [Recipe] {
        switch testCase {
        case .malformedData:
            throw RecipeServiceError.malformedData
        case .emptyData:
            throw RecipeServiceError.emptyData
        case .validData(let recipes):
            return recipes
        }
    }
    
    func loadImage(from url: URL) async -> UIImage? {
        let urlString = url.absoluteString

        // Step 1: Check in-memory cache
        if let cachedImage = inMemoryCache[urlString] {
            return cachedImage
        }

        // Step 2: Check disk cache
        let diskCachedImageURL = getCachedImageURL(for: url)
        if let diskCachedImage = UIImage(contentsOfFile: diskCachedImageURL.path) {
            // Add to in-memory cache and return
            inMemoryCache[urlString] = diskCachedImage
            return diskCachedImage
        }

        // Step 3: Simulate a download (mock response)
        guard let mockImage = UIImage(systemName: "photo") else {
            return nil
        }

        // Cache to memory and disk
        inMemoryCache[urlString] = mockImage
        try? mockImage.pngData()?.write(to: diskCachedImageURL)

        return mockImage
    }

    func getCachedImageURL(for url: URL) -> URL {
        let hashedFileName = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? url.lastPathComponent
        return diskCacheURL.appendingPathComponent(hashedFileName)
    }

    func clearCache() {
        inMemoryCache.removeAll()
        try? fileManager.removeItem(at: diskCacheURL)
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
}
