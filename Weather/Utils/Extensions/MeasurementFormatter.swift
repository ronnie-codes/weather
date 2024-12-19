//
//  MeasurementFormatter.swift
//  Weather
//
//  Created by Ronnie Vega on 12/17/24.
//

import Foundation

extension MeasurementFormatter {
    /// A pre-configured `MeasurementFormatter` for formatting temperature values without explicitly including the unit.
    ///
    /// This formatter is designed for displaying temperatures in a user-friendly format, where the unit is implied
    /// (e.g., "25" instead of "25°C" or "77" instead of "77°F"), depending on the context.
    ///
    /// ### Configuration:
    /// - `unitOptions`: Set to `.temperatureWithoutUnit`, which omits the unit in the output string.
    /// - `numberFormatter.maximumFractionDigits`: Limited to 0 to display whole numbers only.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let temperatureFormatter = MeasurementFormatter.temperature
    ///
    /// let measurement = Measurement(value: 25.3, unit: UnitTemperature.celsius)
    /// let formatted = temperatureFormatter.string(from: measurement)
    /// print(formatted) // "25" (in a locale that uses metric)
    /// ```
    ///
    /// ### Output Examples:
    /// - Input: `25.3°C` → Output: `"25"`
    /// - Input: `77°F` → Output: `"77"`
    static let temperature: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        // Omits the unit (e.g., "25" instead of "25°C").
        formatter.unitOptions = .temperatureWithoutUnit
        // Limits the formatted number to whole numbers.
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
}
