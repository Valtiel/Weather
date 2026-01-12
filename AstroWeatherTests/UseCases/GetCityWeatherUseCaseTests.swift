//
//  GetCityWeatherUseCaseTests.swift
//  AstroWeatherTests
//
//  Created by César Rosales.
//

import Testing
@testable import AstroWeather
import Foundation

struct GetCityWeatherUseCaseTests {
    
    @Test func execute_WithValidCityCode_ReturnsWeatherData() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let expectedWeatherData = createSampleWeatherData()
        mockProvider.weatherDataToReturn = expectedWeatherData
        
        let weatherService = await WeatherService(provider: mockProvider)
        let useCase = await GetCityWeatherUseCase(weatherService: weatherService)
        
        // When
        let result = try await useCase.execute(cityCode: "London")
        
        // Then
        #expect(mockProvider.cityCodeCalled == true)
        #expect(mockProvider.lastCityCode == "London")
        #expect(result.cityName == expectedWeatherData.cityName)
    }
    
    @Test func execute_WithEmptyCityCode_ThrowsError() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let weatherService = await WeatherService(provider: mockProvider)
        let useCase = await GetCityWeatherUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: UseCaseError.self) {
            try await useCase.execute(cityCode: "")
        }
        
        #expect(mockProvider.cityCodeCalled == false)
    }
    
    @Test func execute_WithWhitespaceOnlyCityCode_ThrowsError() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let weatherService = await WeatherService(provider: mockProvider)
        let useCase = await GetCityWeatherUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: UseCaseError.self) {
            try await useCase.execute(cityCode: "   ")
        }
        
        #expect(mockProvider.cityCodeCalled == false)
    }
    
    @Test func execute_WithNewlineOnlyCityCode_ThrowsError() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let weatherService = await WeatherService(provider: mockProvider)
        let useCase = await GetCityWeatherUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: UseCaseError.self) {
            try await useCase.execute(cityCode: "\n\n")
        }
        
        #expect(mockProvider.cityCodeCalled == false)
    }
    
    @Test func execute_WithTrimmedValidCityCode_Succeeds() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let expectedWeatherData = createSampleWeatherData()
        mockProvider.weatherDataToReturn = expectedWeatherData
        
        let weatherService = await WeatherService(provider: mockProvider)
        let useCase = await GetCityWeatherUseCase(weatherService: weatherService)
        
        // When
        let result = try await useCase.execute(cityCode: "  London  ")
        
        // Then - should trim and pass to service
        #expect(mockProvider.cityCodeCalled == true)
        #expect(result.cityName == expectedWeatherData.cityName)
    }
    
    @Test func execute_ErrorPropagation() async throws {
        // Given
        let mockProvider = MockWeatherDataProviderStub()
        let testError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "City not found"])
        mockProvider.errorToThrow = testError
        
        let weatherService = await WeatherService(provider: mockProvider)
        let useCase = await GetCityWeatherUseCase(weatherService: weatherService)
        
        // When/Then
        await #expect(throws: NSError.self) {
            try await useCase.execute(cityCode: "InvalidCity")
        }
    }
    
    // MARK: - Helper Methods
    
    private func createSampleWeatherData() -> WeatherData {
        return WeatherData(
            cityName: "London",
            coordinates: Coordinates(latitude: 51.5074, longitude: -0.1278),
            temperature: Temperature(current: 15.0, feelsLike: 14.0, minimum: 12.0, maximum: 18.0),
            weather: WeatherCondition(id: 801, main: "Clouds", description: "few clouds", icon: "02d"),
            wind: WindInfo(speed: 3.2, direction: 90),
            humidity: 70,
            visibility: 10000,
            timestamp: Date(),
            timezone: 0
        )
    }
}
