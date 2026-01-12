//
//  SunAnimationView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI

struct SunAnimationView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("sunnyBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }
    }
}

#Preview {
    SunAnimationView()
        .ignoresSafeArea()
}
