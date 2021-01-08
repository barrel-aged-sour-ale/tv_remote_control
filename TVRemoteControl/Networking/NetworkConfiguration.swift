import Foundation

struct NetworkConfiguration {
    static let `default`: NetworkConfiguration = NetworkConfiguration(timeoutInterval: 8.0)
    let timeoutInterval: TimeInterval
}
