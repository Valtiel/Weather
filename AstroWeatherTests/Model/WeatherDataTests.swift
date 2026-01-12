//
//  WeatherDataTests.swift
//  AstroWeatherTests
//
//  Created by César Rosales.
//

import Testing
@testable import AstroWeather
import Foundation

struct WeatherDataTests {
    
    // MARK: - WeatherData Tests
    
    @Test func weatherDataInitialization() async throws {
        let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)
        let temperature = Temperature(current: 20.0, feelsLike: 19.0, minimum: 15.0, maximum: 25.0)
        let weatherCondition = WeatherCondition(id: 800, main: "Clear", description: "clear sky", icon: "01d")
        let wind = WindInfo(speed: 5.5, direction: 180)
        let timestamp = Date()
        
        let weatherData = WeatherData(
            cityName: "San Francisco",
            coordinates: coordinates,
            temperature: temperature,
            weather: weatherCondition,
            wind: wind,
            humidity: 65,
            visibility: 10000,
            timestamp: timestamp,
            timezone: -28800
        )
        
        #expect(weatherData.cityName == "San Francisco")
        #expect(weatherData.coordinates.latitude == 37.7749)
        #expect(weatherData.coordinates.longitude == -122.4194)
        #expect(weatherData.temperature.current == 20.0)
        #expect(weatherData.temperature.feelsLike == 19.0)
        #expect(weatherData.temperature.minimum == 15.0)
        #expect(weatherData.temperature.maximum == 25.0)
        #expect(weatherData.weather.id == 800)
        #expect(weatherData.weather.main == "Clear")
        #expect(weatherData.weather.description == "clear sky")
        #expect(weatherData.weather.icon == "01d")
        #expect(weatherData.wind.speed == 5.5)
        #expect(weatherData.wind.direction == 180)
        #expect(weatherData.humidity == 65)
        #expect(weatherData.visibility == 10000)
        #expect(weatherData.timestamp == timestamp)
        #expect(weatherData.timezone == -28800)
    }
    
    // MARK: - Coordinates Tests
    
    @Test func coordinatesInitialization() async throws {
        let coordinates = Coordinates(latitude: 40.7128, longitude: -74.0060)
        
        #expect(coordinates.latitude == 40.7128)
        #expect(coordinates.longitude == -74.0060)
    }
    
    @Test func coordinatesWithNegativeValues() async throws {
        let coordinates = Coordinates(latitude: -33.8688, longitude: 151.2093)
        
        #expect(coordinates.latitude == -33.8688)
        #expect(coordinates.longitude == 151.2093)
    }
    
    // MARK: - Temperature Tests
    
    @Test func temperatureInitialization() async throws {
        let temperature = Temperature(current: 22.5, feelsLike: 21.0, minimum: 18.0, maximum: 27.0)
        
        #expect(temperature.current == 22.5)
        #expect(temperature.feelsLike == 21.0)
        #expect(temperature.minimum == 18.0)
        #expect(temperature.maximum == 27.0)
    }
    
    @Test func temperatureWithNegativeValues() async throws {
        let temperature = Temperature(current: -5.0, feelsLike: -7.0, minimum: -10.0, maximum: 0.0)
        
        #expect(temperature.current == -5.0)
        #expect(temperature.feelsLike == -7.0)
        #expect(temperature.minimum == -10.0)
        #expect(temperature.maximum == 0.0)
    }
    
    // MARK: - WeatherCondition Tests
    
    @Test func weatherConditionInitialization() async throws {
        let condition = WeatherCondition(id: 500, main: "Rain", description: "light rain", icon: "10d")
        
        #expect(condition.id == 500)
        #expect(condition.main == "Rain")
        #expect(condition.description == "light rain")
        #expect(condition.icon == "10d")
    }
    
    @Test func weatherConditionWithVariousTypes() async throws {
        let conditions = [
            WeatherCondition(id: 800, main: "Clear", description: "clear sky", icon: "01d"),
            WeatherCondition(id: 801, main: "Clouds", description: "few clouds", icon: "02d"),
            WeatherCondition(id: 600, main: "Snow", description: "light snow", icon: "13d"),
            WeatherCondition(id: 701, main: "Mist", description: "mist", icon: "50d")
        ]
        
        #expect(conditions.count == 4)
        #expect(conditions[0].main == "Clear")
        #expect(conditions[1].main == "Clouds")
        #expect(conditions[2].main == "Snow")
        #expect(conditions[3].main == "Mist")
    }
    
    // MARK: - WindInfo Tests
    
    @Test func windInfoInitialization() async throws {
        let wind = WindInfo(speed: 10.5, direction: 270)
        
        #expect(wind.speed == 10.5)
        #expect(wind.direction == 270)
    }
    
    @Test func windInfoWithVariousDirections() async throws {
        let northWind = WindInfo(speed: 5.0, direction: 0)
        let eastWind = WindInfo(speed: 5.0, direction: 90)
        let southWind = WindInfo(speed: 5.0, direction: 180)
        let westWind = WindInfo(speed: 5.0, direction: 270)
        
        #expect(northWind.direction == 0)
        #expect(eastWind.direction == 90)
        #expect(southWind.direction == 180)
        #expect(westWind.direction == 270)
    }
    
    @Test func windInfoWithZeroSpeed() async throws {
        let wind = WindInfo(speed: 0.0, direction: 0)
        
        #expect(wind.speed == 0.0)
        #expect(wind.direction == 0)
    }
}
