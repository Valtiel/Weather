//
//  MainCoordinator.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation
import CoreLocation
import SwiftUI

/// Coordinator for the main screen and city weather navigation.
final class MainCoordinator: Coordinator {
    
    private let dependencyContainer: DependencyContainer
    
    /// Initializes the main coordinator.
    /// - Parameter dependencyContainer: The dependency injection container.
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        // Navigation logic if needed
    }
    
    /// Creates the main view.
    /// - Returns: The main SwiftUI view.
    func makeMainView() -> some View {
        MainView(coordinator: self)
    }
    
    /// Creates a city weather view for the specified city.
    /// - Parameter cityCode: The city code, name, or identifier.
    /// - Returns: The city weather SwiftUI view.
    func makeCityWeatherView(cityCode: String) -> some View {
        let viewModel = dependencyContainer.makeCityWeatherViewModel(cityName: cityCode)
        viewModel.loadWeatherData(cityCode: cityCode)
        return CityWeatherView(viewState: viewModel)
    }
    
    /// Creates a city weather view for the current location.
    /// - Returns: The city weather SwiftUI view.
    func makeCurrentLocationWeatherView() -> some View {
        let viewModel = dependencyContainer.makeCityWeatherViewModel()
        let locationService = dependencyContainer.makeLocationService()
        
        return CityWeatherView(viewState: viewModel)
            .task {
                do {
                    let coordinates = try await locationService.requestCurrentLocation()
                    viewModel.loadWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
                } catch {
                    // Error handling is managed by the ViewModel
                    print("Error getting location: \(error)")
                }
            }
    }
}
