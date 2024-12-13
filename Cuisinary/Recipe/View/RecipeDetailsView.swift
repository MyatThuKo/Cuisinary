//
//  RecipeDetailsView.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI

struct RecipeDetailsView: View {
    @ObservedObject var viewModel: RecipeViewModel
    let recipe: Recipe
    @Environment(\.colorScheme) var colorScheme

    @State private var loadedImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(height: 250)
                        .cornerRadius(15)
                        .clipped()
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .onAppear {
                            Task {
                                if let url = URL(string: recipe.photoUrlLarge ?? "") {
                                    loadedImage = await viewModel.loadImage(from: url)
                                }
                            }
                        }
                }

                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text("Cuisine: \(recipe.cuisine)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                if let sourceUrl = recipe.sourceUrl,
                   let youtubeUrl = recipe.youtubeUrl,
                   let videoId = extractYouTubeID(from: youtubeUrl) {
                    SourceAndYouTubeView(sourceURL: sourceUrl, youtubeURL: youtubeUrl, videoId: videoId, viewModel: viewModel)
                }
            }
            .padding(20)
        }
        .background(Color("BGColor"))
    }
    
    /// Method from https://stackoverflow.com/a/41166559
    func extractYouTubeID(from youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
}

struct SourceAndYouTubeView: View {
    var sourceURL: String
    var youtubeURL: String
    var videoId: String
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Button {
                viewModel.send(.openWebUrl(sourceURL))
            } label: {
                HStack {
                    Spacer()
                    Text("Visit Recipe Website")
                        .font(.subheadline)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("BtnBGColor"))
                )
                .foregroundStyle(Color("FGPrimary"))
                .cornerRadius(12)
            }
            .padding(20)
            
            YouTubeVideoPlayerView(videoId: videoId)
                .frame(height: 300)
                .cornerRadius(15)
                .padding(.horizontal)
        }
    }
}

