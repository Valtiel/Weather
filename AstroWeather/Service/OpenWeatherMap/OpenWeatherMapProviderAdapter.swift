//
//  OpenWeatherMapProviderAdapter.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// An adapter that makes OpenWeatherMapProvider conform to the WeatherDataProvider protocol
/// by transforming OpenWeatherMapAPIResponse to the domain WeatherData model.
struct OpenWeatherMapProviderAdapter: WeatherDataProvider {
    
    private let provider: OpenWeatherMapProvider
    
    /// Initializes a new adapter.
    /// - Parameter provider: The OpenWeatherMapProvider instance to adapt.
    init(provider: OpenWeatherMapProvider) {
        self.provider = provider
    }
    
    func getWeatherDataWithCoordinates(lat: Double, lon: Double) async throws -> WeatherData {
        let response = try await provider.getWeatherDataWithCoordinates(lat: lat, lon: lon)
        return transform(response)
    }
    
    func getWeatherDataForCityCode(_ code: String) async throws -> WeatherData {
        let response = try await provider.getWeatherDataForCityCode(code)
        return transform(response)
    }
    
    /// Transforms an OpenWeatherMapAPIResponse to the domain WeatherData model.
    private func transform(_ response: OpenWeatherMapAPIResponse) -> WeatherData {
        let weatherCondition = response.weather.first ?? Weather(
            id: 0,
            main: "Unknown",
            description: "Unknown",
            icon: "01d"
        )
        
        return WeatherData(
            cityName: response.name,
            coordinates: Coordinates(
                latitude: response.coord.lat,
                longitude: response.coord.lon
            ),
            temperature: Temperature(
                current: response.main.temp,
                feelsLike: response.main.feelsLike,
                minimum: response.main.tempMin,
                maximum: response.main.tempMax
            ),
            weather: WeatherCondition(
                id: weatherCondition.id,
                main: weatherCondition.main,
                description: weatherCondition.description,
                icon: weatherCondition.icon
            ),
            wind: WindInfo(
                speed: response.wind.speed,
                direction: response.wind.deg
            ),
            humidity: response.main.humidity,
            visibility: response.visibility,
            timestamp: Date(timeIntervalSince1970: TimeInterval(response.dt)),
            timezone: response.timezone
        )
    }
}