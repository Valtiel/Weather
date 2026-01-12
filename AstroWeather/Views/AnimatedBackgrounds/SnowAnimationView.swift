//
//  SnowAnimationView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI

struct SnowAnimationView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("snowBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                // Multiple snowflakes
                ForEach(0..<30, id: \.self) { index in
                    Snowflake(offset: animationOffset, delay: Double(index) * 0.15)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: -100...0)
                        )
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                    animationOffset = geometry.size.height + 100
                }
            }
        }
    }
}

private struct Snowflake: View {
    let offset: CGFloat
    let delay: Double
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image(systemName: "snowflake")
            .font(.caption)
            .foregroundColor(.white.opacity(0.8))
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .offset(y: offset)
            .offset(x: sin(offset / 50) * 30) // Swaying motion
            .animation(.linear(duration: 6).repeatForever(autoreverses: false).delay(delay), value: offset)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
                // Add resize animation with slight variation per snowflake
                let scaleDuration = 1.5 + Double.random(in: 0...0.5) // Vary duration slightly
                withAnimation(.easeInOut(duration: scaleDuration).repeatForever(autoreverses: true).delay(delay * 0.1)) {
                    scale = 1.5
                }
            }
    }
}

#Preview {
    SnowAnimationView()
        .ignoresSafeArea()
}
