//
//  AstroWeatherApp.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI
import SwiftData

@main
struct AstroWeatherApp: App {
    
    // Dependency injection container
    private let dependencyContainer: DependencyContainer
    private let appCoordinator: AppCoordinator
    
    init() {
        // Initialize dependencies
        self.dependencyContainer = DependencyContainer()
        self.appCoordinator = AppCoordinator(dependencyContainer: dependencyContainer)
    }

    var body: some Scene {
        WindowGroup {
            appCoordinator.makeRootView()
        }
    }
}
