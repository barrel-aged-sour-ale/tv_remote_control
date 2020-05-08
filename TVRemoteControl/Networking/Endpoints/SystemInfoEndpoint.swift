import Foundation

struct SystemInfoEndpoint: APIRouting {
    var method: APIHTTPMethod = .get
    var path: String = "/1/system/name"
}
