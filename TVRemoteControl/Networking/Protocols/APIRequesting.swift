import Foundation

protocol APIRequesting {
    func performRequest<T: Codable, V: APIRouting>(router: V,
                                                   basePath: String,
                                                   configuration: NetworkConfiguration,
                                                   completion: ((Result<T, Error>) -> Void)?)
    func performRequest<T: Codable, V: APIRouting>(router: V,
                                                   basePath: String,
                                                   completion: ((Result<T, Error>) -> Void)?)
}

extension APIRequesting {
    func performRequest<T: Codable, V: APIRouting>(router: V,
                                                   basePath: String,
                                                   completion: ((Result<T, Error>) -> Void)?) {
        performRequest(router: router,
                       basePath: basePath,
                       configuration: NetworkConfiguration.default,
                       completion: completion)
    }
}
