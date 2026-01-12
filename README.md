# AstroWeather

A beautiful, modern iOS weather application built with SwiftUI that provides detailed weather information for cities and your current location. The app features animated weather backgrounds, smooth transitions, and a clean, intuitive interface.

## 🌟 Features

### Core Functionality
- **City Weather**: View detailed weather information for multiple cities (London, Montevideo, Buenos Aires)
- **Current Location**: Get weather data for your current location using GPS
- **Last Selection**: Quick access to your previously viewed location/city
- **Weather Details**: Comprehensive weather information including:
  - Current temperature with feels-like temperature
  - Temperature range (min/max)
  - Weather conditions and descriptions
  - Wind speed and direction
  - Humidity percentage
  - Visibility
  - Timezone information
  - Interactive map showing location

### User Experience
- **Animated Weather Backgrounds**: Dynamic backgrounds that change based on weather conditions:
  - Rain animation with particle effects
  - Snow animation with animated snowflakes
  - Sunny animation
  - Fog animation
  - Cloudy animation
- **Smooth Animations**: Entry animations for all UI components with staggered timing
- **Card-Based UI**: Modern card design with glassmorphism effects
- **Pull-to-Refresh**: Refresh weather data with a simple pull gesture
- **Error Handling**: User-friendly error messages with retry options

## 🏗️ Architecture

AstroWeather follows **Clean Architecture** principles combined with **MVVM-C** (Model-View-ViewModel-Coordinator) pattern, ensuring separation of concerns, testability, and maintainability.

### Architecture Layers

```
┌─────────────────────────────────────────┐
│         View Layer (SwiftUI)            │
│  • CityWeatherView                      │
│  • MainView                             │
│  • AnimatedBackgrounds                  │
│  • Protocol: CityWeatherViewState       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      ViewModel/Presentation Layer       │
│  • CityWeatherViewModel                 │
│  • Conforms to CityWeatherViewState     │
│  • Formats data for display             │
│  • Manages view state (@Published)      │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Use Cases (Business Layer)     │
│  • GetCityWeatherUseCase                │
│  • GetWeatherByCoordinatesUseCase      │
│  • Contains business logic & validation │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│           Service Layer                 │
│  • WeatherService                       │
│  • LocationService                      │
│  • WeatherDataProvider (protocol)       │
│  • LastSelectionStorage                 │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│      Routing/Coordinator Layer         │
│  • AppCoordinator                       │
│  • MainCoordinator                      │
│  • Handles navigation & view creation  │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│      Dependency Injection              │
│  • DependencyContainer                  │
│  • Manages object creation              │
│  • Provides dependencies to layers      │
└─────────────────────────────────────────┘
```

### Key Design Patterns

1. **Protocol-Oriented Design**: Views, services, and coordinators use protocols for abstraction
2. **Dependency Injection**: All dependencies injected via initializers through `DependencyContainer`
3. **Adapter Pattern**: `OpenWeatherMapProviderAdapter` bridges API-specific code to domain protocols
4. **Use Case Pattern**: Business logic encapsulated in reusable use cases
5. **Coordinator Pattern**: Navigation logic separated from views

For detailed architecture documentation, see [ARCHITECTURE.md](AstroWeather/ARCHITECTURE.md).

## 📁 Project Structure

```
AstroWeather/
├── AstroWeatherApp.swift          # App entry point
├── Coordinators/                   # Navigation coordinators
│   ├── AppCoordinator.swift
│   ├── MainCoordinator.swift
│   └── Coordinator.swift
├── DependencyContainer/            # Dependency injection
│   └── DependencyContainer.swift
├── Model/                          # Domain models
│   └── WeatherData.swift
├── Service/                        # Service layer
│   ├── WeatherService.swift
│   ├── LocationService.swift
│   ├── LastSelectionStorage.swift
│   ├── WeatherDataProvider.swift
│   ├── Mock/
│   │   └── MockWeatherDataProvider.swift
│   └── OpenWeatherMap/
│       ├── OpenWeatherMapProvider.swift
│       ├── OpenWeatherMapProviderAdapter.swift
│       └── Model/
│           └── OpenWeatherMapAPIResponse.swift
├── UseCases/                       # Business logic
│   └── GetCityWeatherUseCase.swift
├── ViewModels/                     # Presentation layer
│   └── CityWeatherViewModel.swift
├── Views/                          # SwiftUI views
│   ├── MainView.swift
│   ├── CityWeatherView.swift
│   └── AnimatedBackgrounds/
│       ├── WeatherBackgroundView.swift
│       ├── RainAnimationView.swift
│       ├── SnowAnimationView.swift
│       ├── SunAnimationView.swift
│       ├── FogAnimationView.swift
│       └── CloudyAnimationView.swift
└── Assets.xcassets/                # Images and assets

AstroWeatherTests/                  # Unit tests
├── Model/
│   └── WeatherDataTests.swift
├── Service/
│   ├── WeatherServiceTests.swift
│   └── MockWeatherDataProviderStub.swift
└── UseCases/
    ├── GetCityWeatherUseCaseTests.swift
    └── GetWeatherByCoordinatesUseCaseTests.swift
```

## 🚀 Getting Started

### Prerequisites

- **Xcode**: 15.0 or later
- **iOS**: 15.6 or later
- **Swift**: 5.0 or later
- **OpenWeatherMap API Key**: Get your free API key from [OpenWeatherMap](https://openweathermap.org/api)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd AstroWeather
   ```

2. **Configure API Key**
   - Open `AstroWeather/Info.plist`
   - Replace the `OPEN_WEATHER_API_KEY` value with your API key:
   ```xml
   <key>OPEN_WEATHER_API_KEY</key>
   <string>YOUR_API_KEY_HERE</string>
   ```

3. **Open in Xcode**
   ```bash
   open AstroWeather.xcodeproj
   ```

4. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Configuration

#### Location Services
The app requires location permissions for the "Current Location" feature. The permission request is handled automatically when you first use this feature.

#### API Configuration
The app uses OpenWeatherMap API for weather data. The API key is configured in `Info.plist` and accessed through `DependencyContainer`.

## 🧪 Testing

The project includes comprehensive unit tests for models, services, and use cases.

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme AstroWeather -destination 'platform=iOS Simulator,name=iPhone 15'

# Or use Xcode
# Cmd + U to run all tests
```

### Test Coverage

- ✅ **Model Tests**: Domain models (WeatherData, Coordinates, Temperature, etc.)
- ✅ **Service Tests**: WeatherService with mock providers
- ✅ **Use Case Tests**: Business logic validation and error handling

### Test Structure

Tests are organized by layer:
- `AstroWeatherTests/Model/` - Domain model tests
- `AstroWeatherTests/Service/` - Service layer tests
- `AstroWeatherTests/UseCases/` - Use case tests

## 🛠️ Technologies & Frameworks

### Core Technologies
- **SwiftUI**: Modern declarative UI framework
- **Swift Concurrency**: async/await for asynchronous operations
- **Combine**: Reactive programming (minimal usage)
- **CoreLocation**: Location services
- **MapKit**: Map display and annotations

### Third-Party Services
- **OpenWeatherMap API**: Weather data provider

### Design Patterns
- Clean Architecture
- MVVM-C (Model-View-ViewModel-Coordinator)
- Protocol-Oriented Programming
- Dependency Injection
- Adapter Pattern
- Use Case Pattern

## 📱 Supported Features

### Weather Information
- Current temperature
- Feels-like temperature
- Minimum and maximum temperatures
- Weather conditions (clear, rain, snow, fog, cloudy)
- Wind speed and direction
- Humidity percentage
- Visibility distance
- Timezone information

### Location Features
- City-based weather lookup
- GPS-based current location
- Interactive map with location marker
- Coordinate display

### User Preferences
- Last selection persistence (UserDefaults)
- Quick access to previously viewed locations

## 🎨 UI/UX Features

### Animations
- **Entry Animations**: Staggered animations for all components
- **Weather Backgrounds**: Dynamic animated backgrounds based on conditions
- **Smooth Transitions**: Navigation transitions with matched geometry effects
- **Loading States**: Animated loading indicators
- **Refresh Animation**: Rotating refresh button

### Design Elements
- **Card-Based Layout**: Glassmorphism cards with shadows
- **Material Effects**: Ultra-thin material backgrounds
- **Color Coding**: Different colors for different features
- **Responsive Design**: Adapts to different screen sizes

## 🔧 Code Quality & Best Practices

### Swift Best Practices
- ✅ Proper async/await usage (no Task creation in ViewModels)
- ✅ `@MainActor` for UI-related code
- ✅ Static formatters to avoid recreation
- ✅ No force unwraps (safe optional handling)
- ✅ Proper error handling and propagation
- ✅ Constants for magic numbers
- ✅ Protocol-oriented design

### SwiftUI Best Practices
- ✅ `.task` modifier for async work (cancels on view disappearance)
- ✅ Proper state management (`@State`, `@StateObject`, `@ObservedObject`)
- ✅ View composition without unnecessary wrappers
- ✅ `@ViewBuilder` for conditional views
- ✅ Efficient view updates

### Architecture Best Practices
- ✅ Separation of concerns
- ✅ Dependency injection
- ✅ Testable architecture
- ✅ Single Responsibility Principle
- ✅ Dependency Inversion Principle

## 📝 Key Components

### Views
- **MainView**: City selection and navigation
- **CityWeatherView**: Detailed weather display with animated background
- **WeatherBackgroundView**: Dynamic background selector
- **AnimatedBackgrounds**: Weather-specific animations (Rain, Snow, Sun, Fog, Cloudy)

### ViewModels
- **CityWeatherViewModel**: Manages weather data state and formatting

### Services
- **WeatherService**: Facade for weather data providers
- **LocationService**: Handles location requests with timeout and error handling
- **LastSelectionStorage**: Persists user's last selection

### Use Cases
- **GetCityWeatherUseCase**: Fetches weather by city name
- **GetWeatherByCoordinatesUseCase**: Fetches weather by coordinates with validation

### Coordinators
- **AppCoordinator**: Root coordinator
- **MainCoordinator**: Handles main navigation flow

## 🔐 Security & Privacy

- **Location Data**: Only requested when user explicitly selects "Current Location"
- **API Keys**: Stored in Info.plist (consider using environment variables for production)
- **User Data**: Last selection stored locally in UserDefaults (no cloud sync)

## 🐛 Known Issues & Limitations

- API rate limits apply based on your OpenWeatherMap plan

## 🚧 Future Enhancements

Potential improvements for future versions:
- [ ] Weather forecasts (hourly/daily)
- [ ] Dark mode optimizations
- [ ] Offline caching
- [ ] Unit preferences (Celsius/Fahrenheit)
- [ ] Weather history

## 👤 Author

Created by César Rosales

## 🙏 Acknowledgments

- Weather data provided by [OpenWeatherMap](https://openweathermap.org/)
- Icons from SF Symbols
- Background images from googling

---

For detailed architecture information, see [ARCHITECTURE.md](AstroWeather/ARCHITECTURE.md).
