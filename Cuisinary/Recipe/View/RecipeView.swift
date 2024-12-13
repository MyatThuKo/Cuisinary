//
//  RecipeView.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.componentState.sortedRecipes) { recipe in
                    NavigationLink(
                        destination: RecipeDetailsView(viewModel: viewModel, recipe: recipe)
                    ) {
                        RecipeRow(recipe: recipe, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle()) 
                    .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
        .refreshable {
            await viewModel.refreshRecipes()
        }
    }
}
