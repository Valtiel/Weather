//
//  MockWeatherDataProvider.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// A mock implementation of WeatherDataProvider for testing and preview purposes.
final class MockWeatherDataProvider: WeatherDataProvider {
    
    private let mockData: WeatherData?
    private let mockError: Error?
    private let delay: TimeInterval
    
    /// Initializes a mock provider with predefined data.
    /// - Parameters:
    ///   - mockData: The weather data to return. If nil, will throw an error.
    ///   - mockError: The error to throw. If nil and mockData is provided, will return the data.
    ///   - delay: The delay in seconds before returning the result (simulates network latency).
    init(mockData: WeatherData? = nil, mockError: Error? = nil, delay: TimeInterval = 0.5) {
        self.mockData = mockData ?? Self.defaultMockData
        self.mockError = mockError
        self.delay = delay
    }
    
    func getWeatherDataWithCoordinates(lat: Double, lon: Double) async throws -> WeatherData {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw MockWeatherDataProviderError.noData
        }
        
        // Return modified data with the provided coordinates
        return WeatherData(
            cityName: data.cityName,
            coordinates: Coordinates(latitude: lat, longitude: lon),
            temperature: data.temperature,
            weather: data.weather,
            wind: data.wind,
            humidity: data.humidity,
            visibility: data.visibility,
            timestamp: data.timestamp,
            timezone: data.timezone
        )
    }
    
    func getWeatherDataForCityCode(_ code: String) async throws -> WeatherData {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw MockWeatherDataProviderError.noData
        }
        
        // Return modified data with the city code as the city name
        return WeatherData(
            cityName: code,
            coordinates: data.coordinates,
            temperature: data.temperature,
            weather: data.weather,
            wind: data.wind,
            humidity: data.humidity,
            visibility: data.visibility,
            timestamp: data.timestamp,
            timezone: data.timezone
        )
    }
    
    /// Default mock data for convenience.
    static let defaultMockData = WeatherData(
        cityName: "San Francisco",
        coordinates: Coordinates(latitude: 37.7749, longitude: -122.4194),
        temperature: Temperature(
            current: 22.0,
            feelsLike: 20.0,
            minimum: 18.0,
            maximum: 25.0
        ),
        weather: WeatherCondition(
            id: 800,
            main: "Clear",
            description: "clear sky",
            icon: "01d"
        ),
        wind: WindInfo(speed: 12.0, direction: 270),
        humidity: 58,
        visibility: 10000,
        timestamp: Date(),
        timezone: -28800
    )
}

enum MockWeatherDataProviderError: LocalizedError {
    case noData
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No mock data available"
        }
    }
}