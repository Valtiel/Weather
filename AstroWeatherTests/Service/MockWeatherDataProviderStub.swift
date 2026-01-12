//
//  MockWeatherDataProviderStub.swift
//  AstroWeatherTests
//
//  Created by César Rosales.
//

import Foundation
@testable import AstroWeather

/// A mock implementation of WeatherDataProvider for testing purposes.
final class MockWeatherDataProviderStub: WeatherDataProvider {
    
    var weatherDataToReturn: WeatherData?
    var errorToThrow: Error?
    var coordinatesCalled: Bool = false
    var cityCodeCalled: Bool = false
    var lastLatitude: Double?
    var lastLongitude: Double?
    var lastCityCode: String?
    
    func getWeatherDataWithCoordinates(lat: Double, lon: Double) async throws -> WeatherData {
        coordinatesCalled = true
        lastLatitude = lat
        lastLongitude = lon
        
        if let error = errorToThrow {
            throw error
        }
        
        guard let weatherData = weatherDataToReturn else {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No weather data configured"])
        }
        
        return weatherData
    }
    
    func getWeatherDataForCityCode(_ code: String) async throws -> WeatherData {
        cityCodeCalled = true
        lastCityCode = code
        
        if let error = errorToThrow {
            throw error
        }
        
        guard let weatherData = weatherDataToReturn else {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No weather data configured"])
        }
        
        return weatherData
    }
}
