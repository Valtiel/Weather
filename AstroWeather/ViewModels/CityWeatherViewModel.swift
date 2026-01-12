//
//  CityWeatherViewModel.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation
import MapKit

/// ViewModel that manages the state and logic for the CityWeatherView.
/// Conforms to CityWeatherViewState protocol to work with the view.
@MainActor
final class CityWeatherViewModel: CityWeatherViewState {
    
    // MARK: - Published Properties
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    @Published private(set) var cityName: String = ""
    @Published private(set) var dateLabel: String = ""
    @Published private(set) var iconName: String = ""
    @Published private(set) var temperature: String = ""
    @Published private(set) var temperatureMin: String = ""
    @Published private(set) var temperatureMax: String = ""
    @Published private(set) var weatherSummary: String = ""
    @Published private(set) var wind: String = ""
    @Published private(set) var humidity: String = ""
    @Published private(set) var feelsLike: String = ""
    @Published private(set) var coordinates: CLLocationCoordinate2D? = nil
    @Published private(set) var visibility: String = ""
    @Published private(set) var timezone: String = ""
    
    // MARK: - Private Properties
    
    private let getCityWeatherUseCase: GetCityWeatherUseCase
    private let getWeatherByCoordinatesUseCase: GetWeatherByCoordinatesUseCase
    
    // Store last loaded parameters for refresh
    private var lastLoadedCityCode: String?
    private var lastLoadedCoordinates: (latitude: Double, longitude: Double)?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - Initialization
    
    /// Initializes a new ViewModel.
    /// - Parameters:
    ///   - getCityWeatherUseCase: The use case for fetching city weather data.
    ///   - getWeatherByCoordinatesUseCase: The use case for fetching weather by coordinates.
    init(
        cityName: String?,
        getCityWeatherUseCase: GetCityWeatherUseCase,
        getWeatherByCoordinatesUseCase: GetWeatherByCoordinatesUseCase
    ) {
        self.cityName = cityName ?? ""
        self.getCityWeatherUseCase = getCityWeatherUseCase
        self.getWeatherByCoordinatesUseCase = getWeatherByCoordinatesUseCase
        // Set initial date label to current date
        self.dateLabel = formatDate(Date())
    }
    
    // MARK: - Public Methods
    
    /// Loads weather data for the specified city.
    /// - Parameter cityCode: The city code, name, or identifier.
    func loadWeatherData(cityCode: String) {
        guard !isLoading else { return }
        
        // Store city code for refresh
        lastLoadedCityCode = cityCode
        lastLoadedCoordinates = nil
        
        Task {
            await fetchWeatherData(cityCode: cityCode)
        }
    }
    
    /// Loads weather data for the specified coordinates.
    /// - Parameters:
    ///   - latitude: The latitude coordinate.
    ///   - longitude: The longitude coordinate.
    func loadWeatherData(latitude: Double, longitude: Double) {
        guard !isLoading else { return }
        
        // Store coordinates for refresh
        lastLoadedCityCode = nil
        lastLoadedCoordinates = (latitude: latitude, longitude: longitude)
        
        Task {
            await fetchWeatherData(latitude: latitude, longitude: longitude)
        }
    }
    
    /// Refreshes the weather data using the last loaded parameters.
    func refresh() {
        guard !isLoading else { return }
        
        if let cityCode = lastLoadedCityCode {
            Task {
                await fetchWeatherData(cityCode: cityCode)
            }
        } else if let coordinates = lastLoadedCoordinates {
            Task {
                await fetchWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
        }
    }
    
    func perform(_ action: CityWeatherViewAction) {
        // Handle view actions
        switch action {
        case .refresh:
            refresh()
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchWeatherData(cityCode: String) async {
        isLoading = true
        error = nil
        
        do {
            let weatherData = try await getCityWeatherUseCase.execute(cityCode: cityCode)
            updateProperties(with: weatherData)
        } catch {
            self.error = error
            // Reset to empty state on error
            resetProperties()
        }
        
        isLoading = false
    }
    
    private func fetchWeatherData(latitude: Double, longitude: Double) async {
        isLoading = true
        error = nil
        
        do {
            let weatherData = try await getWeatherByCoordinatesUseCase.execute(
                latitude: latitude,
                longitude: longitude
            )
            updateProperties(with: weatherData)
        } catch {
            self.error = error
            // Reset to empty state on error
            resetProperties()
        }
        
        isLoading = false
    }
    
    private func updateProperties(with weatherData: WeatherData) {
        cityName = weatherData.cityName
        dateLabel = formatDate(Date()) // Use current date instead of API timestamp
        iconName = iconName(for: weatherData.weather.icon)
        temperature = formatTemperature(weatherData.temperature.current)
        temperatureMin = formatTemperature(weatherData.temperature.minimum)
        temperatureMax = formatTemperature(weatherData.temperature.maximum)
        weatherSummary = weatherData.weather.description.capitalized
        wind = formatWind(speed: weatherData.wind.speed, direction: weatherData.wind.direction)
        humidity = "\(weatherData.humidity)%"
        feelsLike = formatTemperature(weatherData.temperature.feelsLike)
        coordinates = CLLocationCoordinate2D(
            latitude: weatherData.coordinates.latitude,
            longitude: weatherData.coordinates.longitude
        )
        visibility = formatVisibility(weatherData.visibility)
        timezone = formatTimezone(weatherData.timezone)
    }
    
    private func resetProperties() {
        cityName = ""
        dateLabel = formatDate(Date()) // Keep current date even on error
        iconName = ""
        temperature = ""
        temperatureMin = ""
        temperatureMax = ""
        weatherSummary = ""
        wind = ""
        humidity = ""
        feelsLike = ""
        coordinates = nil
        visibility = ""
        timezone = ""
    }
    
    // MARK: - Formatting Helpers
    
    private func formatDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    private func formatTemperature(_ temperature: Double) -> String {
        String(format: "%.0f", temperature)
    }
    
    private func formatWind(speed: Double, direction: Int) -> String {
        let directionString = directionToCompass(direction)
        return String(format: "%.0f km/h %@", speed * 3.6, directionString) // Convert m/s to km/h
    }
    
    private func directionToCompass(_ degrees: Int) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                         "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int((Double(degrees) + 11.25) / 22.5) % 16
        return directions[index]
    }
    
    private func iconName(for iconCode: String) -> String {
        // Map OpenWeatherMap icon codes to SF Symbols
        switch iconCode {
        case "01d", "01n": return "sun.max.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d", "10n": return "cloud.sun.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "cloud.snow.fill"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
    
    private func formatVisibility(_ visibility: Int) -> String {
        // Convert meters to kilometers if >= 1000
        if visibility >= 1000 {
            return String(format: "%.1f km", Double(visibility) / 1000.0)
        } else {
            return "\(visibility) m"
        }
    }
    
    private func formatTimezone(_ timezone: Int) -> String {
        // Timezone is in seconds offset from UTC
        let hours = timezone / 3600
        let minutes = abs(timezone % 3600) / 60
        let sign = hours >= 0 ? "+" : ""
        if minutes == 0 {
            return String(format: "UTC%@%d", sign, hours)
        } else {
            return String(format: "UTC%@%d:%02d", sign, hours, minutes)
        }
    }
}
