//
//  ReachabilityService.swift
//  Weather
//
//  Created by Ronnie Vega on 12/16/24.
//
//  Reference: https://tinyurl.com/stackoverflow-reachability-ios
//

import Foundation
import Network

/// Represents the network connectivity status.
/// - `connected`: The device is connected to the network.
/// - `disconnected`: The device is not connected to the network.
enum ReachabilityStatus: String {
    case connected
    case disconnected
}

/// Protocol defining the responsibilities of a reachability service.
/// The reachability service monitors network connectivity and provides the current status.
protocol ReachabilityService {
    /// The current network connectivity status (`connected` or `disconnected`).
    var status: ReachabilityStatus { get }
}

/// Default implementation of `ReachabilityService` using Apple's `Network` framework.
/// This service monitors the network path status and updates the connectivity status in real time.
final class ReachabilityServiceNetwork: ReachabilityService {
    /// The current network connectivity status. Defaults to `.connected`.
    var status: ReachabilityStatus = .connected

    /// The `NWPathMonitor` instance used to monitor network path changes.
    private let monitor: NWPathMonitor

    /// The queue on which the network path monitoring runs.
    private let queue: DispatchQueue

    /// Initializes the reachability service with optional custom monitor and queue.
    /// - Parameters:
    ///   - monitor: The `NWPathMonitor` instance to use. Defaults to a new `NWPathMonitor`.
    ///   - queue: The `DispatchQueue` to run the monitor on. Defaults to a custom queue labeled `"Monitor"`.
    init(monitor: NWPathMonitor = NWPathMonitor(), queue: DispatchQueue = DispatchQueue(label: "Monitor")) {
        self.monitor = monitor
        self.queue = queue

        // Set up the path update handler to monitor network status changes.
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Ensure updates to `status` are published on the main thread.
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    debugPrint("We're connected!")
                    self.status = .connected
                } else {
                    debugPrint("No connection.")
                    self.status = .disconnected
                }
            }
        }

        // Start monitoring the network path on the specified queue.
        monitor.start(queue: queue)
    }
}
