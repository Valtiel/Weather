//
//  WeatherBackgroundView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI

enum WeatherAnimationType {
    case rain
    case snow
    case sun
    case fog
    case cloudy
    case none
    
    static func from(iconName: String) -> WeatherAnimationType {
        switch iconName {
        case "cloud.rain.fill", "cloud.sun.rain.fill":
            return .rain
        case "cloud.snow.fill":
            return .snow
        case "sun.max.fill", "cloud.sun.fill":
            return .sun
        case "cloud.fog.fill":
            return .fog
        case "cloud.fill", "cloud.bolt.fill":
            return .cloudy
        default:
            return .none
        }
    }
}

struct WeatherBackgroundView: View {
    let iconName: String
    
    var body: some View {
        let animationType = WeatherAnimationType.from(iconName: iconName)
        
        ZStack {
            switch animationType {
            case .rain:
                RainAnimationView()
            case .snow:
                SnowAnimationView()
            case .sun:
                SunAnimationView()
            case .fog:
                FogAnimationView()
            case .cloudy:
                CloudyAnimationView()
            case .none:
                Color.clear
            }
        }
    }
}

#Preview("Rain") {
    WeatherBackgroundView(iconName: "cloud.rain.fill")
        .ignoresSafeArea()
}

#Preview("Snow") {
    WeatherBackgroundView(iconName: "cloud.snow.fill")
        .ignoresSafeArea()
}

#Preview("Sun") {
    WeatherBackgroundView(iconName: "sun.max.fill")
        .ignoresSafeArea()
}

#Preview("Fog") {
    WeatherBackgroundView(iconName: "cloud.fog.fill")
        .ignoresSafeArea()
}

#Preview("Cloudy") {
    WeatherBackgroundView(iconName: "cloud.fill")
        .ignoresSafeArea()
}
