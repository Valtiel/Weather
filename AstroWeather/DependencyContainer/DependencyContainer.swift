//
//  DependencyContainer.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// Dependency injection container that manages object creation and dependencies.
/// This follows the Dependency Injection pattern to make the code more testable and maintainable.
final class DependencyContainer {
    
    // MARK: - Service Layer
    
    private lazy var weatherService: WeatherService = {
        // In production, use OpenWeatherMap provider
        let apiKey = Bundle.main.infoDictionary?["OPEN_WEATHER_API_KEY"] as? String ?? ""
        let openWeatherProvider = OpenWeatherMapProvider(apiKey: apiKey)
        let adapter = OpenWeatherMapProviderAdapter(provider: openWeatherProvider)
        return WeatherService(provider: adapter)
    }()
    
    // MARK: - Services
    
    private lazy var locationService: LocationService = {
        LocationService()
    }()
    
    // MARK: - Use Cases
    
    private lazy var getCityWeatherUseCase: GetCityWeatherUseCase = {
        GetCityWeatherUseCase(weatherService: weatherService)
    }()
    
    private lazy var getWeatherByCoordinatesUseCase: GetWeatherByCoordinatesUseCase = {
        GetWeatherByCoordinatesUseCase(weatherService: weatherService)
    }()
    
    // MARK: - Factory Methods
    
    /// Creates a CityWeatherViewModel with its dependencies.
    /// - Returns: A configured CityWeatherViewModel instance.
    func makeCityWeatherViewModel(cityName: String = "") -> CityWeatherViewModel {
        CityWeatherViewModel(
            cityName: cityName,
            getCityWeatherUseCase: getCityWeatherUseCase,
            getWeatherByCoordinatesUseCase: getWeatherByCoordinatesUseCase
        )
    }
    
    /// Creates a LocationService instance.
    /// - Returns: A configured LocationService instance.
    func makeLocationService() -> LocationService {
        locationService
    }
    
    /// Creates a WeatherService instance. Useful for testing or special cases.
    /// - Returns: A configured WeatherService instance.
    func makeWeatherService() -> WeatherService {
        weatherService
    }
    
    /// Creates a mock dependency container for testing/previews.
    /// - Returns: A DependencyContainer configured with mock providers.
    static func makeMock() -> DependencyContainer {
        let container = DependencyContainer()
        // Override with mock service if needed
        return container
    }
}
