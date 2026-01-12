//
//  GetWeatherByCoordinatesUseCaseTests.swift
//  AstroWeatherTests
//
//  Created by César Rosales.
//

import Testing
@testable import AstroWeather
import Foundation

struct GetWeatherByCoordinatesUseCaseTests {
    
    @Test func execute_WithValidCoordinates_ReturnsWeatherData() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let expectedWeatherData = createSampleWeatherData()
        mockProvider.weatherDataToReturn = expectedWeatherData
        
        let weatherService = WeatherService(provider: mockProvider)
        let useCase = GetWeatherByCoordinatesUseCase(weatherService: weatherService)
        
        // When
        let result = try await useCase.execute(latitude: 37.7749, longitude: -122.4194)
        
        // Then
        #expect(mockProvider.coordinatesCalled == true)
        #expect(mockProvider.lastLatitude == 37.7749)
        #expect(mockProvider.lastLongitude == -122.4194)
        #expect(result.cityName == expectedWeatherData.cityName)
    }
    
    @Test func execute_WithLatitudeTooHigh_ThrowsError() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let weatherService = WeatherService(provider: mockProvider)
        let useCase = GetWeatherByCoordinatesUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: UseCaseError.self) {
            try await useCase.execute(latitude: 91.0, longitude: 0.0)
        }
        
        #expect(mockProvider.coordinatesCalled == false)
    }
    
    @Test func execute_WithLatitudeTooLow_ThrowsError() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let weatherService = WeatherService(provider: mockProvider)
        let useCase = GetWeatherByCoordinatesUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: UseCaseError.self) {
            try await useCase.execute(latitude: -91.0, longitude: 0.0)
        }
        
        #expect(mockProvider.coordinatesCalled == false)
    }
    
    @Test func execute_WithLongitudeTooHigh_ThrowsError() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let weatherService = WeatherService(provider: mockProvider)
        let useCase = GetWeatherByCoordinatesUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: UseCaseError.self) {
            try await useCase.execute(latitude: 0.0, longitude: 181.0)
        }
        
        #expect(mockProvider.coordinatesCalled == false)
    }
    
    @Test func execute_WithLongitudeTooLow_ThrowsError() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let weatherService = WeatherService(provider: mockProvider)
        let useCase = GetWeatherByCoordinatesUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: UseCaseError.self) {
            try await useCase.execute(latitude: 0.0, longitude: -181.0)
        }
        
        #expect(mockProvider.coordinatesCalled == false)
    }
    
    @Test func execute_WithBoundaryValues_Succeeds() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let expectedWeatherData = createSampleWeatherData()
        mockProvider.weatherDataToReturn = expectedWeatherData
        
        let weatherService = WeatherService(provider: mockProvider)
        let useCase = GetWeatherByCoordinatesUseCase(weatherService: weatherService)
        
        // When - Test boundary values
        let result1 = try await useCase.execute(latitude: 90.0, longitude: 180.0)
        let result2 = try await useCase.execute(latitude: -90.0, longitude: -180.0)
        let result3 = try await useCase.execute(latitude: 0.0, longitude: 0.0)
        
        // Then
        #expect(result1.cityName == expectedWeatherData.cityName)
        #expect(result2.cityName == expectedWeatherData.cityName)
        #expect(result3.cityName == expectedWeatherData.cityName)
        #expect(mockProvider.coordinatesCalled == true)
    }
    
    @Test func execute_ErrorPropagation() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let testError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        mockProvider.errorToThrow = testError
        
        let weatherService = WeatherService(provider: mockProvider)
        let useCase = GetWeatherByCoordinatesUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: NSError.self) {
            try await useCase.execute(latitude: 37.7749, longitude: -122.4194)
        }
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
