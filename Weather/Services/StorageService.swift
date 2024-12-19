//
//  StorageService.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

import Foundation

/// Protocol defining the responsibilities of a storage service.
/// The storage service provides methods for saving, retrieving, and removing data in a key-value storage system.
///
/// Methods:
/// - `set`: Encodes and stores a value for a specified key.
/// - `get`: Retrieves and decodes a value for a specified key.
/// - `remove`: Removes a value for a specified key.
protocol StorageService {
    /// Saves a value to storage for a specified key.
    /// - Parameters:
    ///   - value: The value to store. Must conform to `Codable`.
    ///   - forKey: The key to associate with the stored value.
    func set<T>(value: T, forKey: String) where T: Codable

    /// Retrieves a value from storage for a specified key.
    /// - Parameter forKey: The key associated with the stored value.
    /// - Returns: The value associated with the key,  decoded into type T, or `nil` if not found or decoding fails.
    func get<T>(forKey: String) -> T? where T: Codable

    /// Removes a value from storage for a specified key.
    /// - Parameter forKey: The key associated with the value to remove.
    func remove(forKey: String)
}

/// Default implementation of `StorageService` using `UserDefaults`.
/// Handles encoding, decoding, and managing key-value data storage.
///
/// Features:
/// - Uses `JSONEncoder` and `JSONDecoder` to encode and decode complex types.
/// - Provides a simple interface for saving, retrieving, and removing data from `UserDefaults`.
final class StorageServiceUserDefaults: StorageService {
    /// The `UserDefaults` instance used for storing and retrieving data.
    private let userDefaults: UserDefaults

    /// The JSON encoder used to encode values before storing them.
    private let encoder: JSONEncoder

    /// The JSON decoder used to decode values after retrieving them.
    private let decoder: JSONDecoder

    /// Initializes the storage service with optional custom encoder, decoder, and `UserDefaults` instance.
    /// - Parameters:
    ///   - userDefaults: The `UserDefaults` instance to use. Defaults to `.standard`.
    ///   - encoder: The `JSONEncoder` to use for encoding. Defaults to a new `JSONEncoder`.
    ///   - decoder: The `JSONDecoder` to use for decoding. Defaults to a new `JSONDecoder`.
    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Saves a value to `UserDefaults` for a specified key.
    /// - Parameters:
    ///   - value: The value to store. Must conform to `Codable`.
    ///   - forKey: The key to associate with the stored value.
    func set<T>(value: T, forKey: String) where T: Codable {
        if let data = try? encoder.encode(value) {
            userDefaults.set(data, forKey: forKey)
        }
    }

    /// Retrieves a value from `UserDefaults` for a specified key.
    /// - Parameter forKey: The key associated with the stored value.
    /// - Returns: The value associated with the key, decoded into type T, or `nil` if not found or decoding fails.
    func get<T>(forKey: String) -> T? where T: Codable {
        if let data = userDefaults.data(forKey: forKey), let value = try? decoder.decode(T.self, from: data) {
            return value
        }
        return nil
    }

    /// Removes a value from `UserDefaults` for a specified key.
    /// - Parameter forKey: The key associated with the value to remove.
    func remove(forKey: String) {
        userDefaults.removeObject(forKey: forKey)
    }
}
