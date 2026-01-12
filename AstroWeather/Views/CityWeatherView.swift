//
//  CityWeatherView.swift
//  AstroWeather
//
//  Created by César Rosales.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation

protocol CityWeatherViewState: ObservableObject {
    
    var isLoading: Bool { get }
    var error: Error? { get }
    
    var cityName: String { get }
    var dateLabel: String { get }
    var iconName: String { get }
    var temperature: String { get }
    var temperatureMin: String { get }
    var temperatureMax: String { get }
    var weatherSummary: String { get }
    var wind: String { get }
    var humidity: String { get }
    var feelsLike: String { get }
    var coordinates: CLLocationCoordinate2D? { get }
    var visibility: String { get }
    var timezone: String { get }
    
    func perform(_ action: CityWeatherViewAction)
    
}

enum CityWeatherViewAction {
    case refresh
}

struct CityWeatherView<ViewState: CityWeatherViewState>: View {
    
    @ObservedObject var viewState: ViewState
    @State private var isBackgroundVisible: Bool = false
    
    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        ZStack {
            // Background weather animation
            WeatherBackgroundView(iconName: viewState.iconName)
                .ignoresSafeArea()
                .opacity(isBackgroundVisible ? 1.0 : 0.0)
            
            ScrollView {
                VStack(spacing: 24) {
                    CityHeaderView(cityName: viewState.cityName,
                                   dateLabel: viewState.dateLabel,
                                   onRefresh: {
                        viewState.perform(.refresh)
                    },
                                   isLoading: viewState.isLoading)
                    if viewState.isLoading {
                        LoadingView()
                    } else if let error = viewState.error {
                        ErrorView(error: error)
                    } else {
                        
                        TemperatureSummaryView(temperature: viewState.temperature,
                                               summary: viewState.weatherSummary,
                                               iconName: viewState.iconName)
                        TemperatureRangeView(min: viewState.temperatureMin, max: viewState.temperatureMax)
                        WeatherInfoRow(wind: viewState.wind,
                                       humidity: viewState.humidity,
                                       feelsLike: viewState.feelsLike)
                        AdditionalInfoRow(visibility: viewState.visibility,
                                          timezone: viewState.timezone)
                        
                        // MapView at the bottom
                        if let coordinate = viewState.coordinates {
                            LocationMapView(
                                coordinate: coordinate,
                                cityName: viewState.cityName,
                                coordinatesString: formatCoordinates(coordinate)
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .task {
            withAnimation(.easeIn(duration: AnimationConstants.backgroundFadeDuration)) {
                isBackgroundVisible = true
            }
        }
    }
    
    private func formatCoordinates(_ coordinate: CLLocationCoordinate2D) -> String {
        String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
}

// MARK: - Card View

private struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: CardViewConstants.cornerRadius)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(CardViewConstants.shadowOpacity), radius: CardViewConstants.shadowRadius, x: 0, y: CardViewConstants.shadowOffsetY)
            )
    }
}

private enum CardViewConstants {
    static let cornerRadius: CGFloat = 16
    static let shadowOpacity: Double = 0.1
    static let shadowRadius: CGFloat = 5
    static let shadowOffsetY: CGFloat = 2
}

private enum AnimationConstants {
    static let backgroundFadeDuration: Double = 0.8
    static let springResponse: Double = 0.6
    static let springDampingFraction: Double = 0.8
    static let headerDelay: Double = 0.1
    static let temperatureRangeDelay: Double = 0.3
    static let weatherInfoDelay: Double = 0.4
    static let additionalInfoDelay: Double = 0.5
    static let mapDelay: Double = 0.6
    static let mapSpringResponse: Double = 0.7
}

private enum WeatherInfoType {
    case wind
    case humidity
    case feelsLike
    case coordinates
    case visibility
    case timezone
    
    var iconName: String {
        switch self {
        case .wind:
            return "wind"
        case .humidity:
            return "humidity"
        case .feelsLike:
            return "thermometer"
        case .coordinates:
            return "mappin.circle"
        case .visibility:
            return "eye"
        case .timezone:
            return "clock"
        }
    }
    
    var label: String {
        switch self {
        case .wind:
            return "Wind"
        case .humidity:
            return "Humidity"
        case .feelsLike:
            return "Feels like"
        case .coordinates:
            return "Coordinates"
        case .visibility:
            return "Visibility"
        case .timezone:
            return "Timezone"
        }
    }
}

private struct CityHeaderView: View {
    let cityName: String
    let dateLabel: String
    let onRefresh: () -> Void
    let isLoading: Bool
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        CardView {
            HStack(alignment: .center, spacing: CityHeaderViewConstants.spacing) {
                VStack(alignment: .leading) {
                    Text(cityName)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(dateLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    onRefresh()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .rotationEffect(.degrees(isLoading ? 360 : 0))
                        .animation(
                            isLoading ? .linear(duration: 1).repeatForever(autoreverses: false) : .default,
                            value: isLoading
                        )
                }
                .disabled(isLoading)
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(x: isVisible ? 0 : -30)
        .onAppear {
            withAnimation(
                .spring(
                    response: AnimationConstants.springResponse,
                    dampingFraction: AnimationConstants.springDampingFraction
                )
                .delay(AnimationConstants.headerDelay)
            ) {
                isVisible = true
            }
        }
    }
    
    // Constants related to CityHeaderView layout and sizing
    private enum CityHeaderViewConstants {
        static let spacing: CGFloat = 12
    }
}

private struct TemperatureSummaryView: View {
    let temperature: String
    let summary: String
    let iconName: String
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        CardView {
            VStack {
                HStack(spacing: TemperatureSummaryViewConstants.spacing) {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: TemperatureSummaryViewConstants.iconBackgroundSize, height: TemperatureSummaryViewConstants.iconBackgroundSize)
                        .foregroundStyle(.yellow, .gray)
                        .scaleEffect(isVisible ? 1.0 : 0.5)
                        .opacity(isVisible ? 1.0 : 0.0)
                    HStack {
                        // Temperature text
                        Text(temperature)
                            .font(.system(size: TemperatureSummaryViewConstants.temperatureFontSize, weight: .semibold))
                            .foregroundStyle(.primary)
                            .scaleEffect(isVisible ? 1.0 : 0.5)
                            .opacity(isVisible ? 1.0 : 0.0)
                        
                        Text("°")
                            .font(.system(size: TemperatureSummaryViewConstants.temperatureFontSize * 0.5, weight: .semibold))
                            .baselineOffset(TemperatureSummaryViewConstants.baselineDegreeOffset)
                            .foregroundStyle(.primary)
                            .scaleEffect(isVisible ? 1.0 : 0.5)
                            .opacity(isVisible ? 1.0 : 0.0)
                    }
                }
                Text(summary)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                isVisible = true
            }
        }
        .padding()
    }
}

private enum TemperatureSummaryViewConstants {
    static let spacing: CGFloat = 16
    static let temperatureFontSize: CGFloat = 50
    static let baselineDegreeOffset: CGFloat = 18
    static let horizontalDegreeOffset: CGFloat = 35
    static let iconBackgroundSize: CGFloat = 75
}

private struct WeatherInfoRow: View {
    let wind: String
    let humidity: String
    let feelsLike: String
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        CardView {
            HStack(spacing: WeatherInfoRowConstants.spacing) {
                WeatherInfoItem(type: .wind, value: wind)
                WeatherInfoItem(type: .humidity, value: humidity)
                WeatherInfoItem(type: .feelsLike, value: feelsLike)
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(
                .spring(
                    response: AnimationConstants.springResponse,
                    dampingFraction: AnimationConstants.springDampingFraction
                )
                .delay(AnimationConstants.weatherInfoDelay)
            ) {
                isVisible = true
            }
        }
    }
    
    // Constants related to WeatherInfoRow spacing
}

private enum WeatherInfoRowConstants {
    static let spacing: CGFloat = 32
}

private struct WeatherInfoItem: View {
    let type: WeatherInfoType
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: type.iconName)
                .font(.title3)
            Text(type.label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct TemperatureRangeView: View {
    let min: String
    let max: String
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        CardView {
            HStack(spacing: 10) {
                Image(systemName: "thermometer.snowflake")
                    .font(.title3)
                Text("Min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(min)°")
                    .font(.title3)
                    .fontWeight(.semibold)
                Divider()
                Image(systemName: "thermometer.sun")
                    .font(.title3)
                Text("Max")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(max)°")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .onAppear {
            withAnimation(
                .spring(
                    response: AnimationConstants.springResponse,
                    dampingFraction: AnimationConstants.springDampingFraction
                )
                .delay(AnimationConstants.temperatureRangeDelay)
            ) {
                isVisible = true
            }
        }
    }
}

private struct AdditionalInfoRow: View {
    let visibility: String
    let timezone: String
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        CardView {
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    WeatherInfoItem(type: .visibility, value: visibility)
                    WeatherInfoItem(type: .timezone, value: timezone)
                }
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(
                .spring(
                    response: AnimationConstants.springResponse,
                    dampingFraction: AnimationConstants.springDampingFraction
                )
                .delay(AnimationConstants.additionalInfoDelay)
            ) {
                isVisible = true
            }
        }
    }
}

// MARK: - Location Map View

private struct LocationMapView: View {
    let coordinate: CLLocationCoordinate2D
    let cityName: String
    let coordinatesString: String
    
    @State private var region: MKCoordinateRegion
    @State private var isVisible: Bool = false
    
    init(coordinate: CLLocationCoordinate2D, cityName: String, coordinatesString: String) {
        self.coordinate = coordinate
        self.cityName = cityName
        self.coordinatesString = coordinatesString
        // Initialize region centered on the coordinate
        self._region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Location")
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: WeatherInfoType.coordinates.iconName)
                            .font(.caption)
                        Text(coordinatesString)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Map(coordinateRegion: $region,
                    annotationItems: [MapAnnotation(coordinate: coordinate, title: cityName)]) { annotation in
                    MapMarker(coordinate: annotation.coordinate, tint: .blue)
                }
                    .frame(height: 250)
                    .cornerRadius(LocationMapViewConstants.mapCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: LocationMapViewConstants.mapCornerRadius)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .scaleEffect(isVisible ? 1.0 : 0.9)
        .onAppear {
            withAnimation(
                .spring(
                    response: AnimationConstants.mapSpringResponse,
                    dampingFraction: AnimationConstants.springDampingFraction
                )
                .delay(AnimationConstants.mapDelay)
            ) {
                isVisible = true
            }
        }
    }
}

private enum LocationMapViewConstants {
    static let mapCornerRadius: CGFloat = 12
}

private struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
}

// MARK: - Loading View

private struct LoadingView: View {
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Loading weather data...")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Error View

private struct ErrorView: View {
    let error: Error
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        CardView {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.orange)
                
                Text("Error")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(error.localizedDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Go Back")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Mock View State

private final class CityWeatherViewStateMock: CityWeatherViewState {
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    @Published var cityName: String = "San Francisco"
    @Published var dateLabel: String = "Today"
    @Published var iconName: String = "sun.max.fill"
    @Published var temperature: String = "22"
    @Published var temperatureMin: String = "18"
    @Published var temperatureMax: String = "25"
    @Published var weatherSummary: String = "Sunny"
    @Published var wind: String = "12Km/h NW"
    @Published var humidity: String = "58%"
    @Published var feelsLike: String = "20°"
    @Published var coordinates: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @Published var visibility: String = "10.0 km"
    @Published var timezone: String = "UTC-8"
    
    func perform(_ action: CityWeatherViewAction) {
        // No-op for preview
    }
}

#Preview {
    CityWeatherView(viewState: CityWeatherViewStateMock())
}
