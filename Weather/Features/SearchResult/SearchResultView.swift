//
//  SearchResultView.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

import SwiftUI
import CachedAsyncImage

/// The `SearchResultView` displays search results for weather queries.
/// It handles the display of content, loading, and error states based on the `viewState` from the provided `ViewModel`.
///
/// Key Features:
/// - Dynamically updates the UI based on `viewState`.
/// - Displays detailed search results in a card format.
/// - Supports reactive updates as the user types in the search query.
///
/// Generic Parameters:
/// - `ViewModel`: A type conforming to `SearchResultViewModel`, responsible for managing the view's state and actions.
struct SearchResultView<ViewModel: SearchResultViewModel>: View {
    /// Environment variable to dismiss the search bar programmatically.
    @Environment(\.dismissSearch) private var dismissSearch

    /// The view model that provides state and actions for the `SearchResultView`.
    @StateObject private var viewModel: ViewModel

    /// A binding to the user's search query.
    @Binding private var query: String

    /// Initializes the `SearchResultView` with a view model and a binding to the search query.
    /// - Parameters:
    ///   - viewModel: The view model responsible for managing the view's state and actions.
    ///   - query: A binding to the user's search query.
    init(viewModel: ViewModel, query: Binding<String>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _query = query
    }

    var body: some View {
        List {
            Group {
                switch viewModel.viewState {
                case .content(let searchResult):
                    // Display a search result card when content is available.
                    SearchResultCard(searchResult: searchResult) {
                        dismissSearch()
                        viewModel.onSelection(of: searchResult)
                    }
                case .loading:
                    // Display a loading indicator while fetching data.
                    ProgressView()
                case .error(let message):
                    // Display an error message when an error occurs.
                    Text(message)
                        .font(Font.custom("Poppins", size: 15))
                        .fontWeight(.regular)
                        .padding()
                }
            }
            .listRowSeparator(.hidden, edges: .all)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .listStyle(.plain)
        // React to changes in the search query and update the view model.
        .onChange(of: query) { _, newValue in
            viewModel.onChange(of: newValue)
        }
    }
}

/// A card component that displays the details of a single search result.
///
/// Features:
/// - Displays the city name, temperature, and weather icon.
/// - Supports user interaction to select the result.
private struct SearchResultCard: View {
    /// The `SearchResult` containing details about the city and weather.
    let searchResult: SearchResult

    /// Action triggered when the card is selected.
    let onSelection: () -> Void

    var body: some View {
        Button(action: onSelection) {
            HStack {
                weatherText
                Spacer()
                weatherIcon
            }
            .frame(minHeight: 117)
            .padding(.horizontal, 31)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(16.0)
        }
    }

    /// Displays the city's name and temperature.
    private var weatherText: some View {
        VStack(alignment: .leading, spacing: -4) {
            Text(searchResult.city.name)
                .font(Font.custom("Poppins", size: 20))
                .fontWeight(.semibold)
                .padding(.top)
            Text(Measurement.temperature(
                    searchResult.weather.tempC, searchResult.weather.tempF, formatter: .temperature)
            )
            .font(Font.custom("Poppins", size: 60))
            .fontWeight(.medium)
        }
    }

    /// Displays the weather condition icon asynchronously.
    private var weatherIcon: some View {
        CachedAsyncImage(url: URL(string: "https:" + searchResult.weather.condition.icon)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
            }
        }
        .frame(width: 83, height: 83)
    }
}

#Preview("Content") {
    let viewModel = SearchResultViewModelMock(viewState: .content(SearchResult.mock))
    SearchResultView(viewModel: viewModel, query: Binding.constant(""))
}

#Preview("Loading") {
    let viewModel = SearchResultViewModelMock(viewState: .loading)
    SearchResultView(viewModel: viewModel, query: Binding.constant(""))
}

#Preview("Error") {
    let errorState = SearchResultViewState.error(.init(stringLiteral: NetworkError.noNetwork.error.message))
    let viewModel = SearchResultViewModelMock(viewState: errorState)
    SearchResultView(viewModel: viewModel, query: Binding.constant(""))
}
