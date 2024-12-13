//
//  YouTubeVideoPlayerView.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubeVideoPlayerView: UIViewRepresentable {
    let videoId: String

    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        return playerView
    }

    func updateUIView(_ playerView: YTPlayerView, context: Context) {
        let playerVars: [String: Any] = [
            "playsinline": 1,
            "autoplay": 0,
        ]
        playerView.load(withVideoId: videoId, playerVars: playerVars)
    }
}
