//
//  Measurement.swift
//  Weather
//
//  Created by Ronnie Vega on 12/17/24.
//

import Foundation

extension Measurement {
    /// Formats a temperature value based on the user's locale and measurement system.
    ///
    /// This method automatically determines whether to use Celsius or Fahrenheit
    /// based on the current locale's measurement system. It then formats the temperature
    /// using the provided `MeasurementFormatter`.
    ///
    /// - Parameters:
    ///   - tempC: The temperature in Celsius.
    ///   - tempF: The temperature in Fahrenheit.
    ///   - formatter: A `MeasurementFormatter` instance used to format the temperature.
    /// - Returns: A localized string representation of the temperature.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let formatter = MeasurementFormatter()
    /// formatter.unitOptions = .providedUnit
    /// formatter.numberFormatter.maximumFractionDigits = 1
    ///
    /// let tempString = Measurement.temperature(30.0, 86.0, formatter: formatter)
    /// print(tempString) // "30°C" for metric locale, "86°F" for imperial locale
    /// ```
    static func temperature(_ tempC: Double, _ tempF: Double, formatter: MeasurementFormatter) -> String {
        // Determine the temperature value and unit based on the user's locale
        let value = Locale.current.measurementSystem == .metric ? tempC : tempF
        let unit = Locale.current.measurementSystem == .metric ? UnitTemperature.celsius : UnitTemperature.fahrenheit

        // Create a Measurement object with the appropriate unit
        let measurement = Measurement<UnitTemperature>(value: value, unit: unit)

        // Format the Measurement object into a localized string
        return formatter.string(from: measurement)
    }
}
