//
//  WeatherServiceTests.swift
//  AstroWeatherTests
//
//  Created by César Rosales.
//

import Testing
@testable import AstroWeather
import Foundation

struct WeatherServiceTests {
    
    @Test func getWeatherDataWithCoordinates_Success() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let expectedWeatherData = createSampleWeatherData()
        mockProvider.weatherDataToReturn = expectedWeatherData
        
        let service = WeatherService(provider: mockProvider)
        
        // When
        let result = try await service.getWeatherData(latitude: 37.7749, longitude: -122.4194)
        
        // Then
        #expect(mockProvider.coordinatesCalled == true)
        #expect(mockProvider.lastLatitude == 37.7749)
        #expect(mockProvider.lastLongitude == -122.4194)
        #expect(result.cityName == expectedWeatherData.cityName)
        #expect(result.coordinates.latitude == expectedWeatherData.coordinates.latitude)
        #expect(result.coordinates.longitude == expectedWeatherData.coordinates.longitude)
    }
    
    @Test func getWeatherDataWithCoordinates_ErrorPropagation() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let testError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockProvider.errorToThrow = testError
        
        let service = WeatherService(provider: mockProvider)
        
        // When/Then
        await #expect(throws: NSError.self) {
            try await service.getWeatherData(latitude: 37.7749, longitude: -122.4194)
        }
        
        #expect(mockProvider.coordinatesCalled == true)
    }
    
    @Test func getWeatherDataWithCityCode_Success() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let expectedWeatherData = createSampleWeatherData()
        mockProvider.weatherDataToReturn = expectedWeatherData
        
        let service = WeatherService(provider: mockProvider)
        
        // When
        let result = try await service.getWeatherData(cityCode: "London")
        
        // Then
        #expect(mockProvider.cityCodeCalled == true)
        #expect(mockProvider.lastCityCode == "London")
        #expect(result.cityName == expectedWeatherData.cityName)
    }
    
    @Test func getWeatherDataWithCityCode_ErrorPropagation() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let testError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "City not found"])
        mockProvider.errorToThrow = testError
        
        let service = WeatherService(provider: mockProvider)
        
        // When/Then
        await #expect(throws: NSError.self) {
            try await service.getWeatherData(cityCode: "InvalidCity")
        }
        
        #expect(mockProvider.cityCodeCalled == true)
        #expect(mockProvider.lastCityCode == "InvalidCity")
    }
    
    // MARK: - Helper Methods
    
    private func createSampleWeatherData() -> WeatherData {
        return WeatherData(
            cityName: "San Francisco",
            coordinates: Coordinates(latitude: 37.7749, longitude: -122.4194),
            temperature: Temperature(current: 20.0, feelsLike: 19.0, minimum: 15.0, maximum: 25.0),
            weather: WeatherCondition(id: 800, main: "Clear", description: "clear sky", icon: "01d"),
            wind: WindInfo(speed: 5.5, direction: 180),
            humidity: 65,
            visibility: 10000,
            timestamp: Date(),
            timezone: -28800
        )
    }
}
