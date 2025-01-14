//
//  HomeRepository.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

import Foundation

/// Protocol defining the responsibilities of the `HomeRepository`.
/// The repository is responsible for managing and fetching weather data.
///
/// Methods:
/// - `getHome()`: Asynchronously retrieves the `Home` data, either from local storage or by making a network request.
protocol HomeRepository {
    /// Retrieves the current `Home` data.
    /// - Returns: An optional `Home` object containing weather information, or `nil` if no data is available.
    func getHome() async -> Home?
    func getHomeAstronomy() async -> HomeAstronomy?
}

/// Default implementation of `HomeRepository`.
/// Handles data fetching from both local storage and a remote API.
/// - If data exists in local storage, it is used as a fallback.
/// - If a valid query is present, an API call is made to fetch the latest data.
///
/// Dependencies:
/// - `NetworkService`: Used for making API requests.
/// - `StorageService`: Used for caching and retrieving local data.
final class HomeRepositoryDefault: HomeRepository {
    /// The network service responsible for making API requests.
    private let networkService: NetworkService

    /// The storage service responsible for caching data locally.
    private let storageService: StorageService

    /// Initializes the repository with required services.
    /// - Parameters:
    ///   - networkService: The network service for API communication.
    ///   - storageService: The storage service for local data management.
    init(networkService: NetworkService, storageService: StorageService) {
        self.networkService = networkService
        self.storageService = storageService
    }

    /// Retrieves the `Home` data, preferring local cache but updating with remote data if available.
    /// - Returns: An optional `Home` object containing the latest weather data.
    func getHome() async -> Home? {
        // Attempt to fetch data from local storage.
        guard let local: Home = storageService.get(forKey: "cache") else {
            return nil
        }

        // If no query is available, return the local data.
        guard let query = local.query else {
            return local
        }

        do {
            // Fetch remote data using the query.
            var remote: Home = try await networkService.request(
                method: .get,
                path: "/current.json",
                params: ["aqi": "no", "key": "08ec2096857f43d39e143822241412", "q": query]
            )

            // Update the query in the remote object and cache it.
            remote.query = query
            putHome(remote)
            return remote
        } catch let error {
            // Log the error and return the local cached data as a fallback.
            debugPrint(error)
            return local
        }
    }

    /// Retrieves the `HomeAstronomy` data, using the query from the local cache.
    /// - Returns: An optional `HomeAstronomy` object containing the latest sunrise/sunset data.
    func getHomeAstronomy() async -> HomeAstronomy? {
        // Attempt to fetch data from local storage.
        guard let local: Home = storageService.get(forKey: "cache"), let query = local.query else {
            return nil
        }

        guard let astronomy: HomeAstronomy = try? await networkService.request(
            method: .get,
            path: "/astronomy.json",
            params: ["key": "08ec2096857f43d39e143822241412", // TODO: INJECT THIS
                     "q": query,
                     "dt": DateFormatter.default.string(from: Date.now)]
        ) else {
            return nil
        }

        return astronomy
    }

    /// Caches the provided `Home` data locally.
    /// - Parameter home: The `Home` object to be cached.
    private func putHome(_ home: Home) {
        storageService.set(value: home, forKey: "cache")
    }
}
