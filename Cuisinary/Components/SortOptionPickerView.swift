//
//  SortOptionPickerView.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI

struct SortOptionPickerView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Sort by")
                .foregroundStyle(Color("FGSecondary"))
                .font(.footnote)
            
            Picker("Sort by", selection: $viewModel.componentState.selectedSortOption) {
                Text("Name").tag(SortOptions.name)
                Text("Cuisine").tag(SortOptions.cuisine)
            }
            .tint(Color("FGPrimary"))
            .pickerStyle(MenuPickerStyle())
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("BtnBGColor"))
            )
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
            .padding(.horizontal)
            .onChange(of: viewModel.componentState.selectedSortOption) {
                viewModel.send(.sortBy(viewModel.componentState.selectedSortOption))
            }
        }
    }
}
