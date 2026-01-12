//
//  FogAnimationView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI

struct FogAnimationView: View {
    @State private var offset1: CGFloat = 0
    @State private var offset2: CGFloat = 0
    @State private var offset3: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("foggyBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                // Multiple fog layers
                FogLayer(offset: offset1, opacity: 0.3)
                    .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: offset1)
                
                FogLayer(offset: offset2, opacity: 0.2)
                    .animation(.linear(duration: 20).repeatForever(autoreverses: false).delay(5), value: offset2)
                
                FogLayer(offset: offset3, opacity: 0.25)
                    .animation(.linear(duration: 18).repeatForever(autoreverses: false).delay(10), value: offset3)
            }
            .onAppear {
                offset1 = geometry.size.width
                offset2 = geometry.size.width
                offset3 = geometry.size.width
            }
        }
    }
}

private struct FogLayer: View {
    let offset: CGFloat
    let opacity: Double
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.white.opacity(opacity))
                        .frame(width: geometry.size.width / 3, height: geometry.size.height / 2)
                        .blur(radius: 30)
                }
            }
            .offset(x: offset)
        }
    }
}

#Preview {
    FogAnimationView()
        .ignoresSafeArea()
}
