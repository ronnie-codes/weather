//
//  ForegroundViewModifier.swift
//  Weather
//
//  Created by Ronnie Vega on 12/17/24.
//

import SwiftUI

/// A `ViewModifier` that listens to changes in the app's `scenePhase`,
/// and executes a closure when the app enters the foreground (`.active` state).
///
/// This modifier uses the `@Environment` property wrapper to observe the `scenePhase`,
/// and triggers the provided closure when the app transitions to `.active`.
private struct ForegroundViewModifier: ViewModifier {
    /// The current scene phase, provided by SwiftUI's environment.
    @Environment(\.scenePhase) private var scenePhase

    /// A closure to be executed when the app becomes active (foreground).
    let onActive: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { _, newPhase in
                switch newPhase {
                case .active:
                    onActive?() // Trigger the closure when the app becomes active.
                default:
                    break // Do nothing for other scene phases.
                }
            }
    }
}

extension View {
    /// Adds a modifier to execute a closure when the app enters the foreground (`.active` state).
    ///
    /// This function provides a convenient way to listen for foreground transitions
    /// and perform actions, such as refreshing data or resuming paused tasks.
    ///
    /// ### Example Usage:
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Text("Hello, World!")
    ///             .onForeground {
    ///                 print("App is now active!")
    ///             }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter perform: A closure to execute when the app enters the foreground.
    /// - Returns: A modified view that listens for foreground transitions.
    func onForeground(perform: @escaping (() -> Void)) -> some View {
        modifier(ForegroundViewModifier(onActive: perform))
    }
}
