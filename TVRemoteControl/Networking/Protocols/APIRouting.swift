import Foundation

enum APIHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol QueryProviding {
    var query: AnyEncodable { get }
}

protocol QueryItemProviding {
    var queryItems: [URLQueryItem] { get }
}

protocol APIRouting: Hashable {
    var method: APIHTTPMethod { get }
    var path: String { get }
}

extension APIRouting {
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(method)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.path == rhs.path && lhs.method == rhs.method
    }
}
