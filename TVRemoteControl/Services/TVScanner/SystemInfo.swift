import Foundation

struct SystemInfo: Decodable {
    private(set) var name: String
    var ipAddress: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}
