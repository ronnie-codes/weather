//
//  WeatherAppCoordinator.swift
//  Weather
//
//  Created by Ronnie Vega on 12/15/24.
//

import SwiftUI

/// `WeatherAppCoordinator` serves as the main coordinator for the Weather app.
/// It manages navigation between the `HomeView` and `SearchResultView` based on the user's search query.
///
/// - The `query` state is used to track the current search input.
/// - Dependencies for networking, storage, and repositories are initialized within the view body.
///
/// Views:
/// - Displays `HomeView` when the search query is empty.
/// - Displays `SearchResultView` when the user provides a search query.
struct WeatherAppCoordinator: View {
    @State private var query = ""

    var body: some View {
        NavigationStack {
            let api = URL(string: "https://api.weatherapi.com/v1")!
            let reachability = ReachabilityServiceNetwork()
            let network = NetworkServiceURLSession(baseURL: api, reachability: reachability)
            let storage = StorageServiceUserDefaults()
            let homeRepository = HomeRepositoryDefault(networkService: network, storageService: storage)
            let homeViewModel = HomeViewModelDefault(repository: homeRepository)
            let searchResultRepository = SearchResultRepositoryDefault(networkService: network, storageService: storage)
            let searchResultViewModel = SearchResultViewModelDefault(repository: searchResultRepository)

            switch query.isEmpty {
            case true:
                HomeView(viewModel: homeViewModel)
                    .id(query)
            case false:
                SearchResultView(viewModel: searchResultViewModel, query: $query)
            }
         }
         .searchable(text: $query, prompt: "home.coordinator.search.title")
         .font(Font.custom("Poppins", size: 15))
         .fontWeight(.regular)
    }
}

#Preview {
    WeatherAppCoordinator()
}
