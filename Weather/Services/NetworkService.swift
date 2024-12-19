//
//  NetworkService.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

import Foundation

/// Represents HTTP methods used for network requests.
/// - `head`: The HTTP `HEAD` method.
/// - `get`: The HTTP `GET` method.
/// - `post`: The HTTP `POST` method.
/// - `put`: The HTTP `PUT` method.
/// - `patch`: The HTTP `PATCH` method.
enum HTTPMethod: String {
    case head
    case get
    case post
    case put
    case patch
}

/// Protocol defining the responsibilities of a network service.
/// The network service handles asynchronous HTTP requests and decodes responses.
///
/// Methods:
/// - `request`: Performs a network request and decodes the response into a specified type.
protocol NetworkService {
    /// Performs a network request with the given parameters.
    /// - Parameters:
    ///   - method: The HTTP method for the request (e.g., `.get`, `.post`).
    ///   - path: The relative path to append to the base URL.
    ///   - params: The query parameters to include in the request.
    /// - Returns: A decoded response of the specified type.
    /// - Throws: A `NetworkError` or other errors if the request fails.
    func request<T: Decodable>(method: HTTPMethod, path: String, params: [String: String]) async throws -> T
}

/// Default implementation of `NetworkService` using `URLSession`.
/// Handles network requests, JSON decoding, and error handling.
///
/// Features:
/// - Integrates with `ReachabilityService` to ensure the device is connected before making a request.
/// - Decodes JSON responses into the specified type or throws appropriate errors.
final class NetworkServiceURLSession: NetworkService {
    /// The base URL for all network requests.
    private let baseURL: URL

    /// The URLSession instance used for network requests.
    private let session: URLSession

    /// The JSON decoder used to decode responses.
    private let decoder: JSONDecoder

    /// The reachability service to check network status before requests.
    private let reachability: ReachabilityService

    /// Initializes the network service with its dependencies.
    /// - Parameters:
    ///   - baseURL: The base URL for all requests.
    ///   - session: The `URLSession` instance to use. Defaults to `URLSession.shared`.
    ///   - decoder: The `JSONDecoder` instance to use. Defaults to a new `JSONDecoder`.
    ///   - reachability: The `ReachabilityService` to check for network availability.
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        reachability: ReachabilityService
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.reachability = reachability
    }

    /// Performs a network request, checks for connectivity, and decodes the response.
    /// - Parameters:
    ///   - method: The HTTP method for the request (e.g., `.get`, `.post`).
    ///   - path: The relative path to append to the base URL.
    ///   - params: The query parameters to include in the request.
    /// - Returns: A decoded response of the specified type.
    /// - Throws: A `NetworkError` or other errors if the request fails.
    func request<T: Decodable>(method: HTTPMethod, path: String, params: [String: String] = [:]) async throws -> T {
        // Ensure network connectivity
        guard reachability.status == .connected else {
            throw NetworkError.noNetwork
        }

        // Build the URL with query parameters
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents?.url else {
            throw NetworkError.generic
        }

        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 10

        // Perform the network request
        let (data, response) = try await session.data(for: request)
        debugPrint(response)
        debugPrint(String(data: data, encoding: .utf8) as Any)

        // Decode the response or throw an error
        if let decodable = try? decoder.decode(T.self, from: data) {
            return decodable
        } else if let error = try? decoder.decode(NetworkError.self, from: data) {
            throw error
        } else {
            throw NetworkError.generic
        }
    }
}

/// Represents errors that may occur during network requests.
/// Can be decoded from a network response or used as a custom error.
struct NetworkError: Error, Decodable {
    /// The payload containing error details, such as a message.
    let error: Payload

    /// Represents the details of an error.
    struct Payload: Decodable {
        /// The human-readable error message.
        let message: String
    }
}

extension NetworkError {
    /// A generic network error with a predefined message.
    static let generic = NetworkError(error: .init(message: "error.generic.title"))

    /// A specific error indicating no network connection.
    static let noNetwork = NetworkError(error: .init(message: "error.noNetwork.title"))
}
