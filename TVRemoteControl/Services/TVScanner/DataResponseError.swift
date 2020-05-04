import Foundation

enum DataResponseError: Error {
    case noTVinNetwork
    case network
    case decoding

    var reason: String {
        switch self {
        case .noTVinNetwork:
            return "There is no PhilipsTV connected to this network"
        case .network:
            return "An error occurred while fetching data "
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}
