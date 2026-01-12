//
//  MainView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI

struct MainView: View {
    let coordinator: MainCoordinator
    
    private let storage = LastSelectionStorage()
    @State private var lastSelection: LastSelection?
    
    private let cities = ["London", "Montevideo", "Buenos Aires"]
    
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                navigationStackBody
            } else {
                navigationViewBody
            }
        }
    }
    
    @available(iOS 16.0, *)
    @ViewBuilder
    private var navigationStackBody: some View {
        NavigationStack {
            contentList
                .navigationTitle("Cities")
                .onAppear {
                    loadLastSelection()
                }
        }
    }
    
    @ViewBuilder
    private var navigationViewBody: some View {
        NavigationView {
            contentList
                .navigationTitle("Cities")
                .onAppear {
                    loadLastSelection()
                }
        }
    }
    
    private var contentList: some View {
        List {
            // Last Selection Section
            if let lastSelection = lastSelection {
                NavigationLink {
                    destinationView(for: lastSelection)
                } label: {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.orange)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Last Selection")
                                .font(.headline)
                            Text(lastSelectionDisplayName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Current Location Section
            NavigationLink {
                coordinator.makeCurrentLocationWeatherView()
                    .onAppear {
                        saveSelection(.currentLocation)
                    }
            } label: {
                HStack {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    Text("Current Location")
                        .font(.headline)
                }
            }
                            
            // Cities Section
            ForEach(cities, id: \.self) { city in
                NavigationLink {
                    coordinator.makeCityWeatherView(cityCode: city)
                        .onAppear {
                            saveSelection(.city(city))
                        }
                } label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.green)
                        Text(city)
                            .font(.headline)
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private var lastSelectionDisplayName: String {
        switch lastSelection {
        case .currentLocation:
            return "Current Location"
        case .city(let name):
            return name
        case .none:
            return ""
        }
    }
    
    private func saveSelection(_ selection: LastSelection) {
        storage.saveLastSelection(selection)
        lastSelection = selection
    }
    
    private func loadLastSelection() {
        lastSelection = storage.getLastSelection()
    }
    
    @ViewBuilder
    private func destinationView(for selection: LastSelection) -> some View {
        switch selection {
        case .currentLocation:
            coordinator.makeCurrentLocationWeatherView()
                .onAppear {
                    saveSelection(.currentLocation)
                }
        case .city(let cityCode):
            coordinator.makeCityWeatherView(cityCode: cityCode)
                .onAppear {
                    saveSelection(.city(cityCode))
                }
        }
    }
}

#Preview {
    let container = DependencyContainer.makeMock()
    let coordinator = MainCoordinator(dependencyContainer: container)
    return MainView(coordinator: coordinator)
}
