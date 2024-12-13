//
//  AnnimatedTextView.swift
//  Cuisinary
//
//  Created by Myat Thu Ko on 12/13/24.
//

import SwiftUI

struct AnimatedTextView: View {
    let text: String
    let fontColor: Color

    @State private var startAnimation: Bool = false
    
    public init(
        text: String,
        fontColor: Color
    ) {
        self.text = text
        self.fontColor = fontColor
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(fontColor)
                    .shadow(color: Color("FGSecondary"), radius: 5, x: 2, y: 2)
                    .offset(y: startAnimation ? -20 : 0)
                    .animation(
                        Animation
                            .spring(response: 0.5, dampingFraction: 0.4)
                            .delay(Double(index) * 0.1)
                            .repeatForever(autoreverses: true),
                        value: startAnimation
                    )
            }
        }
        .onAppear {
            startAnimation = true
        }
        .padding()
    }
}
