//
//  Coordinator.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation
import SwiftUI

/// Protocol that defines the interface for coordinators/routers.
/// Coordinators handle navigation and view creation, keeping views decoupled from navigation logic.
protocol Coordinator: AnyObject {
    /// Starts the coordinator, typically by presenting the initial view.
    func start()
}

/// Protocol for coordinators that can present child coordinators.
protocol ParentCoordinator: Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func addChild(_ coordinator: Coordinator)
    func removeChild(_ coordinator: Coordinator)
}

extension ParentCoordinator {
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}