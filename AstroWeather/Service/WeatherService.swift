//
//  WeatherService.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// A service that provides weather data using a configurable data provider.
/// This service acts as a facade, abstracting the weather data source from the rest of the application.
final class WeatherService {
    
    private let provider: WeatherDataProvider
    
    /// Initializes a new WeatherService.
    /// - Parameter provider: The weather data provider to use for fetching data.
    init(provider: WeatherDataProvider) {
        self.provider = provider
    }
    
    /// Fetches weather data for the specified geographic coordinates.
    /// - Parameters:
    ///   - lat: Latitude.
    ///   - lon: Longitude.
    /// - Returns: The weather data.
    /// - Throws: An error if the weather data cannot be fetched.
    func getWeatherData(latitude: Double, longitude: Double) async throws -> WeatherData {
        return try await provider.getWeatherDataWithCoordinates(lat: latitude, lon: longitude)
    }
    
    /// Fetches weather data for the specified city code or name.
    /// - Parameter cityCode: The city code, name, or identifier.
    /// - Returns: The weather data.
    /// - Throws: An error if the weather data cannot be fetched.
    func getWeatherData(cityCode: String) async throws -> WeatherData {
        return try await provider.getWeatherDataForCityCode(cityCode)
    }
}