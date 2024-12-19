# Weather App

A SwiftUI application designed to display weather information, featuring a clean and modular architecture that allows for dynamic content updates, error handling, and efficient data fetching. This app provides a cohesive and scalable design suitable for future enhancements.

---

## Table of Contents

1. [Features](#features)
2. [Architecture Overview](#architecture-overview)
   - [View Layer](#view-layer)
   - [ViewModel Layer](#viewmodel-layer)
   - [Repository Layer](#repository-layer)
   - [Services Layer](#services-layer)
3. [Setup and Usage](#setup-and-usage)
4. [Key Components](#key-components)
5. [License](#license)

---

## Features

- **Dynamic Weather Search**: Users can search for weather details interactively.
- **Responsive UI**: Leveraging SwiftUI’s declarative syntax, the app dynamically updates based on user input and state changes.
- **Error Handling**: Displays appropriate error messages for network issues or invalid data.
- **Extensible Design**: Built with a layered architecture, enabling seamless addition of new features.

---

## Architecture Overview

The app employs a layered MVVM architecture pattern, which ensures separation of concerns and makes the codebase maintainable and testable.

### View Layer

- **SwiftUI Views**: 
  - `SearchResultView` displays the results of weather searches, handling different states (“Loading,” “Content,” “Error”).
  - `HomeView` displays a summary view when no search query is active.
  - Views are reactive to state changes and use declarative syntax for simplicity and readability.

- **Focus and User Interaction**:
  - Search bar integration through `@FocusState`.
  - Dynamically updates the view model based on user interactions via the `onChange` modifier.

### ViewModel Layer

- **Purpose**: Acts as the glue between the view and the repository layers.
- **Key Responsibilities**:
  - Fetches weather data based on user queries.
  - Maintains and updates the `viewState` (“Loading,” “Content,” “Error”).
  - Handles user interactions, such as search query updates or selection of search results.
- **Implementation**: Conforms to the `SearchResultViewModel` protocol for consistency and extensibility.

### Repository Layer

- **Purpose**: Abstracts data-fetching logic and provides a clean interface to the ViewModel.
- **Key Responsibilities**:
  - Communicates with network and storage services.
  - Manages caching and fallback logic.
  - Decouples the ViewModel from implementation details of data fetching.
- **Components**:
  - `SearchResultRepositoryDefault`
  - `HomeRepositoryDefault`

### Services Layer

- **Purpose**: Provides low-level functionality such as networking and storage.
- **Key Components**:
  - `NetworkServiceURLSession`: Handles API requests and manages connectivity.
  - `ReachabilityServiceNetwork`: Monitors network availability.
  - `StorageServiceUserDefaults`: Caches data locally using `UserDefaults`.

---

## Setup and Usage

### Prerequisites
- Xcode 16 or later
- macOS 15 or later

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ronnie-codes/weather.git
   cd weather
2. Open the project in Xcode:
  `open WeatherApp.xcodeproj`
3. Build and run the project on a simulator or device.

---

## Key Components

### `WeatherAppCoordinator`
- Manages the navigation stack and top-level views (`HomeView`, `SearchResultView`).
- Uses a single `query` state variable to switch between the home and search result screens.

### `SearchResultView`
- Dynamically updates based on `viewState` (Content, Loading, Error).
- Integrates a dismiss action to programmatically close the search bar.

### `HomeView`
- Displays a default screen when no search query is active.

### ViewModel Protocols
- `SearchResultViewModel`: Defines the contract for handling search result logic.
- `HomeViewModel`: Manages the state for the home screen.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
