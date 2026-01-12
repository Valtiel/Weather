//
//  WeatherDataProvider.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// A protocol that defines the interface for fetching weather data.
/// Implementations can provide weather data from various sources (APIs, mocks, etc.).
protocol WeatherDataProvider {
    
    /// Fetches weather data for the specified geographic coordinates.
    /// - Parameters:
    ///   - lat: Latitude.
    ///   - lon: Longitude.
    /// - Returns: The weather data response from the provider's source.
    /// - Throws: An error if the weather data cannot be fetched.
    func getWeatherDataWithCoordinates(lat: Double, lon: Double) async throws -> WeatherData
    
    /// Fetches weather data for the specified city code or name.
    /// - Parameter code: The city code, name, or identifier.
    /// - Returns: The weather data response from the provider's source.
    /// - Throws: An error if the weather data cannot be fetched.
    func getWeatherDataForCityCode(_ code: String) async throws -> WeatherData
}