//
//  SearchResultRepository.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

/// Protocol defining the responsibilities of the `SearchResultRepository`.
/// The repository handles fetching and storing search results.
///
/// Methods:
/// - `putSearchResult`: Caches a `SearchResult` for future use.
/// - `getSearchResult`: Fetches a `SearchResult` for a given query, potentially making a network request.
protocol SearchResultRepository {
    /// Caches a search result for future use.
    /// - Parameter searchResult: The `SearchResult` to cache.
    func putSearchResult(_ searchResult: SearchResult)

    /// Fetches the search result for the specified query.
    /// - Parameter query: The search query string.
    /// - Returns: A `SearchResult` object containing the weather data for the query.
    /// - Throws: An error if the network request fails or the data is invalid.
    func getSearchResult(for query: String) async throws -> SearchResult
}

/// Default implementation of the `SearchResultRepository`.
/// Responsible for managing search result data by interfacing with a network service and a storage service.
///
/// Responsibilities:
/// - Fetches weather data for a search query via a network request.
/// - Caches search results for faster future access.
///
/// Dependencies:
/// - `NetworkService`: Used for making API requests.
/// - `StorageService`: Used for caching search results locally.
final class SearchResultRepositoryDefault: SearchResultRepository {
    /// The network service responsible for making API requests.
    private let networkService: NetworkService

    /// The storage service responsible for caching search results locally.
    private let storageService: StorageService

    /// Initializes the repository with required services.
    /// - Parameters:
    ///   - networkService: The service used to make network requests.
    ///   - storageService: The service used for caching data locally.
    init(networkService: NetworkService, storageService: StorageService) {
        self.networkService = networkService
        self.storageService = storageService
    }

    /// Caches a search result for future use.
    /// - Parameter searchResult: The `SearchResult` to cache.
    func putSearchResult(_ searchResult: SearchResult) {
        storageService.set(value: searchResult, forKey: "cache")
    }

    /// Fetches the search result for a given query by making a network request.
    /// - Parameter query: The search query string.
    /// - Returns: A `SearchResult` object containing weather data for the query.
    /// - Throws: An error if the network request fails or the data is invalid.
    func getSearchResult(for query: String) async throws -> SearchResult {
        // Perform the network request to fetch weather data for the query.
        var searchResult: SearchResult = try await networkService.request(
            method: .get,
            path: "/current.json",
            params: ["aqi": "no", "key": "08ec2096857f43d39e143822241412", "q": query]
        )

        // Attach the query to the fetched result.
        searchResult.query = query

        // Return the fetched result.
        return searchResult
    }
}
