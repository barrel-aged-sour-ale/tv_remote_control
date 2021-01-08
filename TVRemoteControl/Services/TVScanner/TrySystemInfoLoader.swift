import Foundation

struct TrySystemInfoLoader: TrySystemInfoLoading {
    let engine: APIRequesting = URLSessionEngine(completionQueue: .main)

    func tryLoadSystemInfo(for ipAddress: String, completion: @escaping (Result<SystemInfo, Error>) -> Void) {
        engine.performRequest(router: SystemInfoEndpoint(), basePath: "http://\(ipAddress):1925") { (result: Result<SystemInfo, Error>) in
            switch result {
            case var .success(systemInfo):
                systemInfo.ipAddress = ipAddress
                completion(.success(systemInfo))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
