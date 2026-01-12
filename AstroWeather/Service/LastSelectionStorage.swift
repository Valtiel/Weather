//
//  LastSelectionStorage.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import Foundation

/// Represents a stored selection for quick access
enum LastSelection: Codable {
    case currentLocation
    case city(String)
}

/// Service for storing and retrieving the last selected location/city
final class LastSelectionStorage {
    
    private let userDefaults: UserDefaults
    private let key = "lastSelection"
    
    /// Initializes the storage service.
    /// - Parameter userDefaults: The UserDefaults instance to use. Defaults to .standard.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    /// Saves the last selection.
    /// - Parameter selection: The selection to save.
    func saveLastSelection(_ selection: LastSelection) {
        if let encoded = try? JSONEncoder().encode(selection) {
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    /// Retrieves the last selection.
    /// - Returns: The last selection if available, nil otherwise.
    func getLastSelection() -> LastSelection? {
        guard let data = userDefaults.data(forKey: key),
              let selection = try? JSONDecoder().decode(LastSelection.self, from: data) else {
            return nil
        }
        return selection
    }
    
    /// Clears the last selection.
    func clearLastSelection() {
        userDefaults.removeObject(forKey: key)
    }
}
