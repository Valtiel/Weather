//
//  CloudyAnimationView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI

struct CloudyAnimationView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("cloudyBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }
    }
}

#Preview {
    CloudyAnimationView()
        .ignoresSafeArea()
}
