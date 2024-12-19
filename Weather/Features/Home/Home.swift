//
//  Home.swift
//  Weather
//
//  Created by Ronnie Vega on 12/14/24.
//

import Foundation

/// The `Home` struct represents the primary data model for the weather application.
/// It contains information about the current city and weather conditions.
///
/// Conformance:
/// - `Identifiable`: Provides a unique `id` for use in SwiftUI views.
/// - `Codable`: Supports encoding and decoding for API communication and local storage.
struct Home: Identifiable, Codable {
    // swiftlint:disable nesting

    /// A unique identifier for the `Home` object, useful for SwiftUI's `ForEach` and other identifiable collections.
    let id = UUID()

    /// The query string used to fetch this `Home` object (e.g., city name or zip code).
    var query: String?

    /// Information about the city, such as its name.
    let city: City

    /// Weather information for the city.
    let weather: Weather

    /// Coding keys for decoding and encoding the JSON data.
    /// Maps `city` to `location` and `weather` to `current`.
    enum CodingKeys: String, CodingKey {
        case query
        case city = "location"
        case weather = "current"
    }

    /// Represents the city information.
    struct City: Codable {
        /// The name of the city.
        let name: String
    }

    /// Represents the weather information for the city.
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

extension Home {
    /// A mock instance of `Home` for use in previews and testing.
    static let mock = Home(
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
