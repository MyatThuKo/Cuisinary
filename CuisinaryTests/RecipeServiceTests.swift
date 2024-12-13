//
//  RecipeServiceTests.swift
//  CuisinaryTests
//
//  Created by Myat Thu Ko on 12/13 /24.
//

import XCTest

@testable import Cuisinary

final class RecipeServiceTests: XCTestCase {
    
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
    
    func testFetchRecipeData_malformedData() async {
        let mockService = MockRecipeService(testCase: .malformedData)
        
        do {
            _ = try await mockService.fetchRecipeData(endPoint: API.Endpoint.malformedData)
            XCTFail("Expected malformedData error, but no error was thrown")
        } catch let error as RecipeServiceError {
            XCTAssertEqual(error, .malformedData, "Expected malformedData error")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRecipeData_emptyData() async {
        let mockService = MockRecipeService(testCase: .emptyData)
        
        do {
            _ = try await mockService.fetchRecipeData(endPoint: API.Endpoint.emptyData)
            XCTFail("Expected emptyData error, but no error was thrown")
        } catch let error as RecipeServiceError {
            XCTAssertEqual(error, .emptyData, "Expected emptyData error")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRecipeData_validData() async {
        let mockService = MockRecipeService(testCase: .validData(mockRecipes))
        
        do {
            let recipes = try await mockService.fetchRecipeData(endPoint: API.Endpoint.allRecipes)
            XCTAssertEqual(recipes.first?.name, mockRecipes.first?.name)
            XCTAssertEqual(recipes.first?.cuisine, mockRecipes.first?.cuisine)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

