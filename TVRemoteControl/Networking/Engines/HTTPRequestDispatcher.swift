import Foundation

enum HTTPRequestDispatcherError: Error {
    case invalidURL
}

struct HTTPRequestDispatcher: RequestDispatching {
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    func dispatch<T: APIRouting>(_ router: T,
                                 basePath: String,
                                 configuration: NetworkConfiguration,
                                 completion: @escaping RequestDispatcherCompletion) {
        guard let request = try? urlRequest(from: router, with: basePath, with: configuration.timeoutInterval) else {
            completion(nil, HTTPRequestDispatcherError.invalidURL, nil)
            return
        }
        session.dataTask(with: request, completionHandler: { data, response, error in
            completion(data, error, response as? HTTPURLResponse)
        }).resume()
    }

    private func urlRequest<T: APIRouting>(from router: T, with basePath: String, with timeoutInterval: TimeInterval) throws -> URLRequest {
        guard let baseURL = URL(string: basePath) else {
            throw HTTPRequestDispatcherError.invalidURL
        }
        var urlComponents = URLComponents(string: baseURL.appendingPathComponent(router.path).absoluteString)

        if let queryItemProvider = router as? QueryItemProviding {
            urlComponents?.queryItems = queryItemProvider.queryItems
        }

        guard let url = urlComponents?.url else {
            throw HTTPRequestDispatcherError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let queryProvider = router as? QueryProviding {
            urlRequest.httpBody = try JSONEncoder().encode(queryProvider.query)
        }

        urlRequest.timeoutInterval = timeoutInterval

        return urlRequest
    }
}
