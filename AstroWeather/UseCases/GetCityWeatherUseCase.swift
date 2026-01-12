//
//  GetCityWeatherUseCase.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// Use case for fetching weather data for a city by its code or name.
/// This encapsulates the business logic for retrieving city weather information.
final class GetCityWeatherUseCase {
    
    private let weatherService: WeatherService
    
    /// Initializes a new use case.
    /// - Parameter weatherService: The weather service to use for fetching data.
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    /// Executes the use case to fetch weather data for a city.
    /// - Parameter cityCode: The city code, name, or identifier.
    /// - Returns: The weather data for the specified city.
    /// - Throws: An error if the weather data cannot be fetched.
    func execute(cityCode: String) async throws -> WeatherData {
        // Business logic can be added here (validation, caching, etc.)
        guard !cityCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw UseCaseError.invalidInput("City code cannot be empty")
        }
        
        return try await weatherService.getWeatherData(cityCode: cityCode)
    }
}

/// Use case for fetching weather data by coordinates.
final class GetWeatherByCoordinatesUseCase {
    
    private let weatherService: WeatherService
    
    /// Initializes a new use case.
    /// - Parameter weatherService: The weather service to use for fetching data.
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    /// Executes the use case to fetch weather data for coordinates.
    /// - Parameters:
    ///   - latitude: The latitude coordinate.
    ///   - longitude: The longitude coordinate.
    /// - Returns: The weather data for the specified coordinates.
    /// - Throws: An error if the weather data cannot be fetched.
    func execute(latitude: Double, longitude: Double) async throws -> WeatherData {
        // Business logic validation
        guard (-90...90).contains(latitude) else {
            throw UseCaseError.invalidInput("Latitude must be between -90 and 90")
        }
        
        guard (-180...180).contains(longitude) else {
            throw UseCaseError.invalidInput("Longitude must be between -180 and 180")
        }
        
        return try await weatherService.getWeatherData(latitude: latitude, longitude: longitude)
    }
}

enum UseCaseError: LocalizedError {
    case invalidInput(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return message
        }
    }
}