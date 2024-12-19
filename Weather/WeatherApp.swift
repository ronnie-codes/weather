//
//  WeatherApp.swift
//  Weather
//
//  Created by Ronnie Vega on 12/14/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            // The root view of the app, responsible for coordinating navigation and dependencies.
            WeatherAppCoordinator()
        }
    }
}
