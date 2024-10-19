//
//  NetworkManager.swift
//  To-Do List
//
//  Created by Sooraj R on 19/10/24.
//

import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    var isConnected = false

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            if self.isConnected {
                // Trigger background sync when network becomes available
                SyncApiData.shared.syncTasksWithAPI()
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
