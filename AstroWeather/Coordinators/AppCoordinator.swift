//
//  AppCoordinator.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation
import SwiftUI

/// Main application coordinator that manages the overall navigation flow.
final class AppCoordinator: ParentCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private let dependencyContainer: DependencyContainer
    
    /// Initializes the app coordinator.
    /// - Parameter dependencyContainer: The dependency injection container.
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        // In a SwiftUI app, navigation starts from the root view
        // The coordinator pattern here is more for organizing navigation logic
        // For pure SwiftUI, we typically use NavigationStack with routing
    }
    
    /// Creates the root view for the application.
    /// - Returns: The root SwiftUI view.
    func makeRootView() -> some View {
        MainCoordinator(dependencyContainer: dependencyContainer).makeMainView()
    }
}