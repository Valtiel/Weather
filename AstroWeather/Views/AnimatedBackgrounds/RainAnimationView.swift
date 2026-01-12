//
//  RainAnimationView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI

struct RainAnimationView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("rainBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                // Multiple rain drops
                ForEach(0..<50, id: \.self) { index in
                    RainDrop(offset: animationOffset, delay: Double(index) * 0.2)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: -100...0)
                        )
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    animationOffset = geometry.size.height + 100
                }
            }
        }
    }
}

private struct RainDrop: View {
    let offset: CGFloat
    let delay: Double
    
    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.6))
            .frame(width: 2, height: 12)
            .offset(y: offset)
            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(delay), value: offset)
    }
}

#Preview {
    RainAnimationView()
        .ignoresSafeArea()
}
