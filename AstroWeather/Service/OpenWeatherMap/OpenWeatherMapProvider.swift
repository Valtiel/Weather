//
//  OpenWeatherMapProvider.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation
import Combine

/// A provider that fetches weather data from the OpenWeatherMap API.
final class OpenWeatherMapProvider {

    private let apiKey: String
    private let baseURL: String
    private let path: String
    private let session: URLSession
    
    /// Initializes a new OpenWeatherMapProvider.
    /// - Parameters:
    ///   - apiKey: The API key for OpenWeatherMap.
    ///   - baseURL: The base URL of the OpenWeatherMap API.
    ///   - path: The API path for weather data requests.
    ///   - session: The URLSession used for network requests.
    init(
        apiKey: String,
        baseURL: String = "https://api.openweathermap.org",
        path: String = "/data/2.5/weather",
        session: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.path = path
        self.session = session
    }
    
    /// Fetches weather data for the specified geographic coordinates.
    /// - Parameters:
    ///   - lat: Latitude.
    ///   - lon: Longitude.
    /// - Returns: The weather data response.
    func getWeatherDataWithCoordinates(lat: Double, lon: Double) async throws -> OpenWeatherMapAPIResponse {
        let queryItems = [
            URLQueryItem(name: "lat", value: String(format: "%f", lat)),
            URLQueryItem(name: "lon", value: String(format: "%f", lon)),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        return try await fetchWeatherData(queryItems: queryItems)
    }
    
    /// Fetches weather data for the specified city code.
    /// - Parameter code: The city code.
    /// - Returns: The weather data response.
    func getWeatherDataForCityCode(_ code: String) async throws -> OpenWeatherMapAPIResponse {
        let queryItems = [
            URLQueryItem(name: "q", value: code),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        return try await fetchWeatherData(queryItems: queryItems)
    }
    
    /// Private helper method to perform the network request and decode the response.
    /// - Parameter queryItems: The query items to append to the URL.
    /// - Returns: The decoded OpenWeatherMapAPIResponse.
    private func fetchWeatherData(queryItems: [URLQueryItem]) async throws -> OpenWeatherMapAPIResponse {
        var builder = WeatherServiceBuilder(baseUrl: baseURL, path: path)
        for item in queryItems {
            builder = builder.addQueryItem(name: item.name, value: item.value ?? "")
        }
        let url = builder.build()
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw OpenWeatherMapProviderError.invalidResponse
        }
        
        do {
            let weatherData = try JSONDecoder().decode(OpenWeatherMapAPIResponse.self, from: data)
            return weatherData
        } catch is DecodingError {
            throw OpenWeatherMapProviderError.decodingError
        }
    }
}

private struct WeatherServiceBuilder {
    private let baseUrl: String
    private var path: String
    private var queryItems: [URLQueryItem] = []
    
    init(baseUrl: String, path: String) {
        self.baseUrl = baseUrl
        self.path = path
    }
    
    func addQueryItem(name: String, value: String) -> WeatherServiceBuilder {
        var copy = self
        copy.queryItems.append(URLQueryItem(name: name, value: value))
        return copy
    }
    
    func build() -> URL {
        var components = URLComponents(string: baseUrl)!
        components.path = path
        components.queryItems = queryItems
        return components.url!
    }
}

enum OpenWeatherMapProviderError: LocalizedError {
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode cities data"
        }
    }
}
