//
//  RecipeRow.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeViewModel
    @State private var imageLoading: Bool = false
    @State private var loadedImage: UIImage?

    var body: some View {
        HStack(spacing: 15) {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .clipped()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
                    .clipped()
                    .foregroundColor(.gray)
                    .onAppear {
                        Task {
                            if let imageUrl = recipe.photoUrlSmall, let url = URL(string: imageUrl) {
                                loadedImage = await viewModel.loadImage(from: url)
                            }
                        }
                    }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("BtnBGColor"))
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .onAppear {
            guard !imageLoading else { return }
            imageLoading = true
            Task {
                if let imageUrl = recipe.photoUrlSmall, let url = URL(string: imageUrl) {
                    loadedImage = await viewModel.loadImage(from: url)
                }
                imageLoading = false
            }
        }
        .onDisappear {
            loadedImage = nil
        }
    }
}
