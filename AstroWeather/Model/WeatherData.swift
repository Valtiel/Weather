//
//  WeatherData.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// Domain model representing weather data, independent of any specific API implementation.
struct WeatherData {
    let cityName: String
    let coordinates: Coordinates
    let temperature: Temperature
    let weather: WeatherCondition
    let wind: WindInfo
    let humidity: Int
    let visibility: Int
    let timestamp: Date
    let timezone: Int
}

/// Geographic coordinates.
struct Coordinates {
    let latitude: Double
    let longitude: Double
}

/// Temperature information.
struct Temperature {
    let current: Double
    let feelsLike: Double
    let minimum: Double
    let maximum: Double
}

/// Weather condition information.
struct WeatherCondition {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

/// Wind information.
struct WindInfo {
    let speed: Double
    let direction: Int
}