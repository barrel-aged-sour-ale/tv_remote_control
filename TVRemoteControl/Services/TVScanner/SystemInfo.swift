import Foundation

struct SystemInfo: Codable {
    let name: String
    var ipAddress: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}
