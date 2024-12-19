//
//  SearchResultViewModel.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

import Foundation

/// Represents the different states of the `SearchResultView`.
/// - `loading`: The view is currently fetching data.
/// - `content`: Displays a `SearchResult` when data is successfully fetched.
/// - `error`: Shows an error message when fetching data fails.
enum SearchResultViewState {
    case loading
    case content(SearchResult)
    case error(LocalizedStringResource)
}

/// Protocol defining the responsibilities of the `SearchResultViewModel`.
/// Conforms to `ObservableObject` to allow SwiftUI views to react to state changes.
protocol SearchResultViewModel: ObservableObject {
    /// The current state of the `SearchResultView`, such as loading, content, or error.
    var viewState: SearchResultViewState { get }

    /// Called when the search query changes, triggering a new search.
    /// - Parameter query: The updated search query string.
    func onChange(of query: String)

    /// Called when the user selects a search result.
    /// - Parameter searchResult: The selected `SearchResult`.
    func onSelection(of searchResult: SearchResult)
}

/// Default implementation of `SearchResultViewModel`.
/// Manages the state of the search results and handles user interactions.
///
/// Responsibilities:
/// - Fetches search results from the `SearchResultRepository`.
/// - Updates the `viewState` to reflect loading, content, or error states.
/// - Handles search result selection by caching the selected result.
final class SearchResultViewModelDefault: SearchResultViewModel {
    /// Published property to notify the view of state changes.
    @Published var viewState: SearchResultViewState = .loading

    /// The repository responsible for fetching and storing search results.
    private let repository: SearchResultRepository

    /// Initializes the view model with a repository.
    /// - Parameter repository: The repository used to fetch and store search results.
    init(repository: SearchResultRepository) {
        self.repository = repository
    }

    /// Called when the search query changes.
    /// Triggers a new search and updates the view state.
    /// - Parameter query: The updated search query string.
    func onChange(of query: String) {
        guard !query.isEmpty else {
            return
        }
        fetchResult(for: query)
    }

    /// Called when a search result is selected.
    /// Stores the selected result in the repository.
    /// - Parameter searchResult: The selected `SearchResult`.
    func onSelection(of searchResult: SearchResult) {
        repository.putSearchResult(searchResult)
    }

    /// Fetches the search result for a given query.
    /// Updates the view state to reflect the result or an error if fetching fails.
    /// - Parameter query: The search query string.
    private func fetchResult(for query: String) {
        Task { @MainActor in
            do {
                // Fetch the search result from the repository.
                let result = try await repository.getSearchResult(for: query)
                self.viewState = .content(result)
            } catch let error as NetworkError {
                // Handle network-specific errors.
                self.viewState = .error(.init(stringLiteral: error.error.message))
            } catch let error {
                // Handle general errors.
                self.viewState = .error(.init(stringLiteral: error.localizedDescription))
            }
        }
    }
}

/// Mock implementation of `SearchResultViewModel` for testing purposes.
/// Allows simulation of different `SearchResultViewState` scenarios.
final class SearchResultViewModelMock: SearchResultViewModel {
    /// Published property to simulate different states of the view.
    @Published var viewState: SearchResultViewState

    /// Initializes the mock view model with a specific state.
    /// - Parameter viewState: The initial state to simulate.
    init(viewState: SearchResultViewState) {
        self.viewState = viewState
    }

    /// No-op implementation for `onChange` in the mock.
    func onChange(of query: String) {}

    /// No-op implementation for `onSelection` in the mock.
    func onSelection(of searchResult: SearchResult) {}
}
