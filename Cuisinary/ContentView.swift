//
//  ContentView.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    Text("Cuisinary")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color("BtnBGColor"))
                        .padding(.top, 10)
                    
                    SearchBarView(viewModel: viewModel)
                    
                    HStack {
                        FilterPickerView(viewModel: viewModel)
                        
                        SortOptionPickerView(viewModel: viewModel)
                    }
                    
                    if viewModel.componentState.sortedRecipes.isEmpty {
                        emptyStateView
                    } else {
                        RecipeView(viewModel: viewModel)
                    }
                }
                .padding(10)
            }
            .background(Color("BGColor"))
            .navigationTitle("Dish Discovery")
            .toolbar(.hidden)
            .overlay(
                loadingView
            )
            .refreshable {
                await viewModel.refreshRecipes()
            }
            .onAppear {
                Task {
                    try await viewModel.fetchRecipes()
                }
            }
        }
        .tint(Color("FGPrimary"))
    }
    
    var loadingView: some View {
        Group {
            if viewModel.loadingState == .loading {
                AnimatedTextView(text: "LOADING...", fontColor: .init(red: 31, green: 112, blue: 181))
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 0) {
            Text("No recipes available")
                .foregroundStyle(Color("FGPrimary"))
            
            Image("empty-case")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .padding(.vertical)
    }
}
