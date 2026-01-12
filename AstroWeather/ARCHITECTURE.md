# AstroWeather Architecture

## Overview

AstroWeather follows **Clean Architecture** principles combined with **MVVM-C** (Model-View-ViewModel-Coordinator) pattern. This architecture ensures separation of concerns, testability, and maintainability.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│         View Layer (SwiftUI)            │
│  • CityWeatherView                      │
│  • MainView                             │
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
│         Use Cases (Business Layer)      │
│  • GetCityWeatherUseCase                │
│  • GetWeatherByCoordinatesUseCase       │
│  • Contains business logic & validation │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│           Service Layer                 │
│  • WeatherService                       │
│  • WeatherDataProvider (protocol)       │
│  • Handles data fetching                │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│      Routing/Coordinator Layer          │
│  • AppCoordinator                       │
│  • MainCoordinator                      │
│  • Handles navigation & view creation   │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│      Dependency Injection               │
│  • DependencyContainer                  │
│  • Manages object creation              │
│  • Provides dependencies to layers      │
└─────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. View Layer
- **Purpose**: UI rendering using SwiftUI
- **Responsibilities**:
  - Display data from ViewModels
  - Handle user interactions
  - Declarative UI definition
- **Key Points**:
  - Views are generic over `ViewState` protocol (protocol-oriented design)
  - Views don't know about business logic or data sources
  - Views receive `ObservableObject` view states via dependency injection

### 2. ViewModel/Presentation Layer
- **Purpose**: Bridge between Views and Business Logic
- **Responsibilities**:
  - Transform domain models to display-friendly formats
  - Manage view state (@Published properties)
  - Handle async operations (Task/async-await)
  - Format data (dates, temperatures, etc.)
- **Key Points**:
  - Conforms to `CityWeatherViewState` protocol
  - Uses Use Cases for business operations
  - `@MainActor` ensures UI updates on main thread
  - No direct service layer access

### 3. Use Cases (Business Layer)
- **Purpose**: Encapsulate business logic
- **Responsibilities**:
  - Validate inputs
  - Orchestrate business operations
  - Apply business rules
  - Coordinate with services
- **Key Points**:
  - Single Responsibility Principle (one use case = one business operation)
  - Reusable across different ViewModels
  - Testable in isolation
  - Uses Service layer for data access

### 4. Service Layer
- **Purpose**: Abstract data sources
- **Responsibilities**:
  - Fetch data from providers
  - Transform API models to domain models (via adapters)
  - Handle data source abstraction
- **Key Points**:
  - Uses `WeatherDataProvider` protocol for abstraction
  - Supports multiple implementations (OpenWeatherMap, Mock, etc.)
  - Adapter pattern bridges providers to protocol
  - Returns domain models (`WeatherData`)

### 5. Coordinator/Routing Layer
- **Purpose**: Handle navigation and view creation
- **Responsibilities**:
  - Create views with dependencies
  - Manage navigation flow
  - Decouple navigation logic from views
- **Key Points**:
  - Protocol-based (`Coordinator` protocol)
  - Coordinators create views via factory methods
  - Views don't know about navigation details
  - Supports parent-child coordinator relationships

### 6. Dependency Container
- **Purpose**: Dependency Injection container
- **Responsibilities**:
  - Create and manage object instances
  - Wire dependencies between layers
  - Provide factory methods for object creation
- **Key Points**:
  - Single source of truth for dependencies
  - Supports testing with mock implementations
  - Lazy initialization of dependencies
  - Configuration management (API keys, etc.)

## Data Flow

### Fetching Weather Data Flow:

1. **View** → User interaction triggers action
2. **ViewModel** → Calls `loadWeatherData(cityCode:)`
3. **Use Case** → `GetCityWeatherUseCase.execute(cityCode:)`
   - Validates input
   - Calls service
4. **Service** → `WeatherService.getWeatherData(cityCode:)`
   - Uses `WeatherDataProvider` protocol
5. **Provider** → Fetches from API (via adapter)
   - Transforms API response to domain model
6. **Domain Model** → `WeatherData` flows back up
7. **ViewModel** → Updates `@Published` properties
8. **View** → SwiftUI automatically updates UI

## Key Design Patterns

### 1. Protocol-Oriented Design
- Views use protocols (`CityWeatherViewState`)
- Services use protocols (`WeatherDataProvider`)
- Coordinators use protocols (`Coordinator`)
- Enables easy testing and multiple implementations

### 2. Dependency Injection
- All dependencies injected via initializers
- `DependencyContainer` manages object creation
- Enables testability and flexibility

### 3. Adapter Pattern
- `OpenWeatherMapProviderAdapter` adapts `OpenWeatherMapProvider` to `WeatherDataProvider`
- Keeps existing code intact while adding abstraction
- Allows multiple providers to work with same interface

### 4. Use Case Pattern
- Each business operation is a use case
- Encapsulates business logic
- Reusable and testable

### 5. Coordinator Pattern
- Handles navigation logic
- Decouples views from navigation
- Makes navigation testable

## Testing Strategy

### Unit Tests
- **Use Cases**: Test business logic and validation
- **ViewModels**: Test state management and formatting (with mock use cases)
- **Services**: Test with mock providers

### Integration Tests
- Test use case + service + provider together
- Test coordinator navigation flows

### UI Tests
- Test complete user flows
- Use mock providers for predictable data

## Benefits of This Architecture

✅ **Separation of Concerns**: Each layer has a clear responsibility
✅ **Testability**: Easy to test each layer in isolation
✅ **Maintainability**: Changes in one layer don't affect others
✅ **Scalability**: Easy to add new features
✅ **Flexibility**: Easy to swap implementations (e.g., different API providers)
✅ **Protocol-Oriented**: Enables multiple implementations
✅ **Type Safety**: Strong typing throughout

## Dependencies Between Layers

- **Views** → ViewModels (via protocol)
- **ViewModels** → Use Cases
- **Use Cases** → Services
- **Services** → Providers (via protocol)
- **Coordinators** → DependencyContainer
- **App** → DependencyContainer + Coordinators

## Best Practices Followed

1. ✅ Single Responsibility Principle
2. ✅ Dependency Inversion Principle
3. ✅ Protocol-Oriented Programming
4. ✅ Clean Architecture principles
5. ✅ SOLID principles
6. ✅ Separation of concerns
7. ✅ Dependency Injection
8. ✅ Testable architecture
