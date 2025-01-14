//
//  HomeViewModel.swift
//  Weather
//
//  Created by Ronnie Vega on 12/14/24.
//

import Foundation

/// Represents the different states of the `HomeView`.
/// - `content`: Displays weather data for the current location.
/// - `empty`: Indicates no data is available.
/// - `loading`: Represents a loading state while fetching data.
enum HomeViewState {
    case content(Home, HomeAstronomy)
    case empty
    case loading
}

/// Protocol defining the responsibilities of a `HomeViewModel`.
/// Conforms to `ObservableObject` to allow SwiftUI views to react to state changes.
protocol HomeViewModel: ObservableObject {
    /// The current state of the `HomeView`, such as content, empty, or loading.
    var viewState: HomeViewState { get }

    /// Called when the view appears on screen.
    func onAppear()

    /// Called when the app returns to the foreground.
    func onForeground()
}

/// Default implementation of `HomeViewModel`.
/// Fetches weather data and manages the `HomeViewState`.
final class HomeViewModelDefault: HomeViewModel {
    /// Published property to notify the view of state changes.
    @Published var viewState: HomeViewState = .loading

    /// The repository responsible for fetching weather data.
    private let repository: HomeRepository

    /// Initializes the `HomeViewModelDefault` with a repository.
    /// - Parameter repository: The repository used to fetch weather data.
    init(repository: HomeRepository) {
        self.repository = repository
    }

    /// Called when the view appears. Triggers a data fetch.
    func onAppear() {
        fetchHome()
    }

    /// Called when the app returns to the foreground. Triggers a data refresh.
    func onForeground() {
        fetchHome()
    }

    /// Fetches weather data asynchronously and updates the view state.
    private func fetchHome() {
        Task { @MainActor in
            // Both calls happen concurrently
            async let home = repository.getHome()
            async let astronomy = repository.getHomeAstronomy()

            if let home = await home, let astronomy = await astronomy {
                viewState = .content(home, astronomy)
            } else {
                viewState = .empty
            }
        }
    }
}

/// Mock implementation of `HomeViewModel` for testing purposes.
/// Allows simulation of different `HomeViewState` scenarios.
final class HomeViewModelMock: HomeViewModel {
    /// Published property to simulate different states of the view.
    @Published var viewState: HomeViewState

    /// Initializes the mock view model with a specific state.
    /// - Parameter viewState: The initial state to simulate.
    init(viewState: HomeViewState) {
        self.viewState = viewState
    }

    /// No-op implementation for `onAppear` in the mock.
    func onAppear() {}

    /// No-op implementation for `onForeground` in the mock.
    func onForeground() {}
}
