//
//  RecipeViewModel.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import Foundation
import UIKit

enum SortOptions {
    case name
    case cuisine
}

class RecipeViewModel: ObservableObject {
    
    struct ComponentState {
        var searchText: String = ""
        var selectedCuisine: String = "All"
        var selectedSortOption: SortOptions = .name
        var sortedRecipes: [Recipe] = []
    }

    enum LoadingState: Equatable {
        case initial
        case loading
        case loaded
        case error(String)
    }
    
    enum Action {
        case sortBy(SortOptions)
        case filterByCuisine(String)
        case search(String)
        case openWebUrl(String)
    }
    
    // MARK: Properties
    @Published var recipes: [Recipe] = []
    @Published var loadingState: LoadingState = .initial
    @Published var cuisines: [String] = ["All"]
    @Published var componentState: ComponentState = ComponentState()
    
    private let service: RecipeServiceProtocol
    
    // MARK: Initializer
    init(service: RecipeServiceProtocol = RecipeService.shared) {
        self.service = service
        Task {
            await fetchRecipes()
        }
    }
    
    func refreshRecipes() async {
        await fetchRecipes()
    }
    
    @MainActor
    func fetchRecipes() async {
        loadingState = .loading
        
        do {
            let data = try await service.fetchRecipeData(endPoint: API.Endpoint.allRecipes)
            self.recipes = data
            self.cuisines = Array(Set(data.map { $0.cuisine })).sorted()
            self.cuisines.insert("All", at: 0)
            
            getSortedRecipes(by: componentState.selectedSortOption)
            loadingState = .loaded
        } catch {
            print("Failed to load recipes: \(error.localizedDescription)")
            loadingState = .error("Failed to load recipes: \(error.localizedDescription)")
        }
    }

    func send(_ action: Action) {
        switch action {
        case .sortBy(let sortOption):
            componentState.selectedSortOption = sortOption
            getSortedRecipes(by: sortOption)
        case .filterByCuisine(let cuisine):
            componentState.selectedCuisine = cuisine
            getSortedRecipes(by: componentState.selectedSortOption)
        case .search(let query):
            componentState.searchText = query
            getSortedRecipes(by: componentState.selectedSortOption)
        case .openWebUrl(let urlString):
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func getFilteredRecipes() -> [Recipe] {
        return recipes.filter { recipe in
            (componentState.selectedCuisine == "All" || recipe.cuisine == componentState.selectedCuisine) &&
            (componentState.searchText.isEmpty || recipe.name.lowercased().contains(componentState.searchText.lowercased()))
        }
    }
    
    private func getSortedRecipes(by sortOption: SortOptions) {
        let filteredRecipes = getFilteredRecipes()
        
        switch sortOption {
        case .name:
            componentState.sortedRecipes = filteredRecipes.sorted(by: { $0.name < $1.name })
        case .cuisine:
            componentState.sortedRecipes = filteredRecipes.sorted(by: { $0.cuisine < $1.cuisine })
        }
    }
    
    func loadImage(from url: URL) async -> UIImage? {
        return await service.loadImage(from: url)
    }
}

