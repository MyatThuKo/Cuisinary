//
//  SearchBarView.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @State private var fontColor = Color("FGSecondary")
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color("FGPrimary"))
                .padding(.leading, 10)
            
            TextField("Search recipes...", text: $viewModel.componentState.searchText)
                .foregroundStyle(fontColor)
                .padding(10)
                .background(Color.clear)
                .onChange(of: viewModel.componentState.searchText) {
                    viewModel.send(.search(viewModel.componentState.searchText))
                    fontColor = Color("FGPrimary")
                }
                .overlay(
                    HStack {
                        Spacer()
                        if !viewModel.componentState.searchText.isEmpty {
                            Button(action: {
                                viewModel.componentState.searchText = ""
                                viewModel.send(.search(""))
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color("FGPrimary"))
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                )
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("BtnBGColor"))
        )
        .cornerRadius(12)
    }
}

