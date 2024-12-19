//
//  HomeView.swift
//  Weather
//
//  Created by Ronnie Vega on 12/14/24.
//

import SwiftUI
import CachedAsyncImage

/// The `HomeView` is the main interface for displaying weather information.
/// It uses a `List` to organize content and dynamically switches between content, empty, and loading states
/// based on the `viewState` provided by the `ViewModel`.
///
/// Key Features:
/// - Displays weather details when data is available (`.content` state).
/// - Shows a loading spinner during data fetching (`.loading` state).
/// - Displays an empty state when no data is available (`.empty` state).
///
/// This view relies on dependency injection for its `ViewModel`, which conforms to the `HomeViewModel` protocol.
struct HomeView<ViewModel: HomeViewModel>: View {
    /// The view model responsible for managing the state and actions of the `HomeView`.
    @StateObject private var viewModel: ViewModel

    /// Initializes the `HomeView` with the provided view model.
    /// - Parameter viewModel: The view model conforming to `HomeViewModel`.
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .content(let home):
                List {
                    Spacer()
                        .listRowSeparator(.hidden, edges: .all)
                    HomeContentView(home: home)
                        .listRowSeparator(.hidden, edges: .all)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listStyle(.plain)
            case .empty:
                emptyView
            case .loading:
                loadingView
            }
        }
        .onAppear(perform: viewModel.onAppear) // Triggered when the view appears.
        .onForeground(perform: viewModel.onForeground) // Triggered when the app enters the foreground.
    }

    /// A view displayed when no data is available (`.empty` state).
    private var emptyView: some View {
        VStack(spacing: 19) {
            Text("home.view.empty.title")
                .font(Font.custom("Poppins", size: 30))
                .fontWeight(.semibold)
            Text("home.view.empty.subtitle")
                .font(Font.custom("Poppins", size: 15))
                .fontWeight(.semibold)
        }
        .padding(.bottom, 100)
    }

    /// A view displayed when data is loading (`.loading` state).
    private var loadingView: some View {
        ProgressView()
            .padding(.bottom, 100)
    }
}

/// The `HomeContentView` displays the main weather information for a location.
/// This includes the weather icon, location name, current temperature, and weather details.
private struct HomeContentView: View {
    /// The `Home` model containing weather data for the current location.
    let home: Home

    var body: some View {
        VStack(spacing: 35) {
            VStack(spacing: 8) {
                weatherIcon
                locationText
                temperatureText
            }
            weatherDetailCard
        }
        .padding(.horizontal)
    }

    /// Displays the weather condition icon fetched asynchronously.
    private var weatherIcon: some View {
        CachedAsyncImage(url: URL(string: "https:" + home.weather.condition.icon)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
            }
        }
        .frame(width: 123, height: 123)
    }

    /// Displays the location name with a location icon.
    private var locationText: some View {
        HStack(spacing: 10) {
            Text(home.city.name)
                .font(Font.custom("Poppins", size: 30))
                .fontWeight(.semibold)
                .fixedSize(horizontal: false, vertical: true)
            Image(systemName: "location.fill")
                .resizable()
                .frame(width: 21, height: 21)
        }
    }

    /// Displays the current temperature in a large font.
    private var temperatureText: some View {
        Text(Measurement.temperature(home.weather.tempC, home.weather.tempF, formatter: .temperature))
            .font(Font.custom("Poppins", size: 70))
            .fontWeight(.medium)
            .padding(.trailing, 8)
    }

    /// Displays a horizontal card showing weather details like humidity, UV index, and "feels like" temperature.
    private var weatherDetailCard: some View {
        HStack(spacing: 56) {
            WeatherDetailCardStack(
                localizedTitle: "home.view.card.humidity",
                subtitle: String(home.weather.humidity) + "%"
            )
            WeatherDetailCardStack(
                localizedTitle: "home.view.card.uv",
                subtitle: String(Int(home.weather.uvIndex.rounded()))
            )
            WeatherDetailCardStack(
                localizedTitle: "home.view.card.feelslike",
                subtitle: Measurement.temperature(
                    home.weather.feelsLikeC, home.weather.feelsLikeF, formatter: .temperature)
            )
        }
        .padding(24)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(16.0)
    }
}

/// A reusable card component displaying weather detail titles and values in a stack.
private struct WeatherDetailCardStack: View {
    let localizedTitle: LocalizedStringKey
    let subtitle: String

    var body: some View {
        VStack(spacing: 4) {
            Text(localizedTitle)
                .foregroundColor(Color(uiColor: .lightGray))
                .font(Font.custom("Poppins", size: 12))
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(Font.custom("Poppins", size: 15))
                .fontWeight(.medium)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview("Content") {
    let viewModel = HomeViewModelMock(viewState: .content(Home.mock))
    HomeView(viewModel: viewModel)
}

#Preview("Empty") {
    let viewModel = HomeViewModelMock(viewState: .empty)
    HomeView(viewModel: viewModel)
}

#Preview("Loading") {
    let viewModel = HomeViewModelMock(viewState: .loading)
    HomeView(viewModel: viewModel)
}
