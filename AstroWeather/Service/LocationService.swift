//
//  LocationService.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation
import CoreLocation
import Combine

/// Protocol that defines the interface for location services.
/// This abstraction allows for easy testing and different implementations.
protocol LocationServiceProtocol {
    /// Requests the current location of the user.
    /// - Returns: The current location coordinates.
    /// - Throws: An error if location cannot be obtained.
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D
    
    /// The authorization status for location services.
    var authorizationStatus: CLAuthorizationStatus { get }
}

/// A service that handles location requests using CoreLocation.
@MainActor
final class LocationService: NSObject, LocationServiceProtocol {
    
    private let locationManager: CLLocationManager
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    /// Initializes a new LocationService.
    /// - Parameter locationManager: The CLLocationManager instance to use.
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestCurrentLocation() async throws -> CLLocationCoordinate2D {
        // Check authorization status
        switch authorizationStatus {
        case .notDetermined:
            // Request permission first
            locationManager.requestWhenInUseAuthorization()
            // Wait for user response (will be handled in delegate)
            // For now, we'll check after a short delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // Check authorization status again after request
            if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                throw LocationServiceError.permissionDenied
            }
            
            if locationManager.authorizationStatus == .notDetermined {
                // Still not determined, might need more time or user dismissed
                throw LocationServiceError.permissionDenied
            }
            
        case .denied, .restricted:
            throw LocationServiceError.permissionDenied
            
        case .authorizedWhenInUse, .authorizedAlways:
            break
            
        @unknown default:
            throw LocationServiceError.unknownAuthorizationStatus
        }
        
        // Request location
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.first else {
                locationContinuation?.resume(throwing: LocationServiceError.locationNotFound)
                locationContinuation = nil
                return
            }
            
            locationContinuation?.resume(returning: location.coordinate)
            locationContinuation = nil
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            locationContinuation?.resume(throwing: error)
            locationContinuation = nil
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Handle authorization changes if needed
    }
}

enum LocationServiceError: LocalizedError {
    case permissionDenied
    case locationNotFound
    case unknownAuthorizationStatus
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied. Please enable location services in Settings."
        case .locationNotFound:
            return "Unable to determine your current location."
        case .unknownAuthorizationStatus:
            return "Unknown location authorization status."
        }
    }
}
