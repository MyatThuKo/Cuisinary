//
//  RecipeViewModelTests.swift
//  CuisinaryTests
//
//  Created by Myat Thu Ko on 12/13/24.
//

import XCTest

@testable import Cuisinary

final class RecipeViewModelTests: XCTestCase {
    
    var viewModel: RecipeViewModel!
    var mockService: MockRecipeService! 
    
    let mockRecipes = [
        Recipe(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            uuid: "1",
            youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        ),
        Recipe(
            cuisine: "British",
            name: "Apple & Blackberry Crumble",
            photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
            photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
            sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
            uuid: "2",
            youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"
        )
    ]
    
    func testFetchRecipesSuccess() async {
        mockService = MockRecipeService(testCase: .validData(mockRecipes))
        viewModel = RecipeViewModel(service: mockService)
        
        await viewModel.fetchRecipes()
        
        XCTAssertEqual(viewModel.loadingState, .loaded, "Expected loading state to be 'loaded'.")
        XCTAssertEqual(viewModel.recipes.count, 2, "Should have fetched 2 recipes.")
        XCTAssertEqual(viewModel.componentState.sortedRecipes.count, 2, "Sorted recipes should match the number of fetched recipes.")
        XCTAssertEqual(viewModel.cuisines, ["All", "British", "Malaysian"], "Cuisines should include 'All', 'British', and 'Malaysian'.")
    }
    
    func testFetchRecipesError() async {
        mockService = MockRecipeService(testCase: .malformedData)
        viewModel = RecipeViewModel(service: mockService)
        
        await viewModel.fetchRecipes()
        
        if case let .error(message) = viewModel.loadingState {
            XCTAssertTrue(message.contains("Failed to load recipes"), "Expected error message in loading state.")
        } else {
            XCTFail("Expected error state but got \(viewModel.loadingState)")
        }
    }
    
    func testImageIsCachedInMemory() async {
        let mockService = MockRecipeService(testCase: .validData(mockRecipes))

        let testURL = URL(string: mockRecipes[0].photoUrlSmall!)!

        // Load the image for the first time (this simulates a "download")
        let firstImageLoad = await mockService.loadImage(from: testURL)
        XCTAssertNotNil(firstImageLoad, "Image should be loaded.")

        // Verify that the image is in the in-memory cache
        let cachedImage = await mockService.loadImage(from: testURL)
        XCTAssertNotNil(cachedImage, "Image should be retrieved from in-memory cache.")
    }
    
    func testImageIsCachedToDisk() async {
        let mockService = MockRecipeService(testCase: .validData(mockRecipes))

        let testURL = URL(string: mockRecipes[0].photoUrlSmall!)!

        // Load the image for the first time (this simulates a "download" and disk cache)
        let firstImageLoad = await mockService.loadImage(from: testURL)
        XCTAssertNotNil(firstImageLoad, "Image should be loaded and cached.")

        // Clear the in-memory cache
        mockService.clearCache()

        // Load the image again (this should load from disk)
        let secondImageLoad = await mockService.loadImage(from: testURL)
        XCTAssertNotNil(secondImageLoad, "Image should be loaded from disk cache.")
    }
}

