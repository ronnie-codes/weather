//
//  SearchResult.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

import Foundation

/// Represents a search result containing weather information for a specific location.
/// This model conforms to `Identifiable`, `Codable`, and `Hashable` to support:
/// - SwiftUI's `ForEach` and other identifiable collections.
/// - Encoding and decoding for API communication and local storage.
/// - Hashing for use in sets or dictionaries.
struct SearchResult: Identifiable, Codable {
    // swiftlint:disable nesting

    /// A unique identifier for the search result, generated automatically.
    let id = UUID()

    /// The query string used to fetch this search result (e.g., city name or zip code).
    var query: String?

    /// Information about the city, including its name.
    let city: City

    /// Weather details for the specified city.
    let weather: Weather

    /// Coding keys for decoding and encoding the JSON data.
    /// Maps `city` to `location` and `weather` to `current`.
    enum CodingKeys: String, CodingKey {
        case query
        case city = "location"
        case weather = "current"
    }

    /// Represents the city information, such as its name.
    struct City: Codable {
        /// The name of the city.
        let name: String
    }

    /// Represents weather information for the city.
    struct Weather: Codable {
        /// The current humidity level as a percentage.
        let humidity: Int

        /// The uvIndex at the current time.
        let uvIndex: Double

        /// The "feels like" temperature in Celsius.
        let feelsLikeC: Double

        /// The "feels like" temperature in Fahrenheit.
        let feelsLikeF: Double

        /// The current temperature in Celsius.
        let tempC: Double

        /// The current temperature in Fahrenheit.
        let tempF: Double

        /// Detailed weather condition, such as icons for the weather state.
        let condition: Condition

        /// Coding keys for decoding and encoding the JSON data.
        /// Maps JSON keys like `feelslike_c` and `feelslike_f` to the corresponding Swift properties.
        enum CodingKeys: String, CodingKey {
            case humidity
            case uvIndex = "uv"
            case feelsLikeC = "feelslike_c"
            case feelsLikeF = "feelslike_f"
            case tempC = "temp_c"
            case tempF = "temp_f"
            case condition
        }

        /// Represents detailed weather condition information, such as icons.
        struct Condition: Codable {
            /// The icon URL for the current weather condition.
            let icon: String
        }
    }

    // swiftlint:enable nesting
}

extension SearchResult {
    /// A mock instance of `SearchResult` for use in previews and testing.
    static let mock =
        SearchResult(
            city: City(name: "London"),
            weather: Weather(
                humidity: 20,
                uvIndex: 4,
                feelsLikeC: 38.0,
                feelsLikeF: 100.4,
                tempC: 31.0,
                tempF: 87.8,
                condition: .init(icon: "//cdn.weatherapi.com/weather/64x64/night/116.png")
            )
        )
}
