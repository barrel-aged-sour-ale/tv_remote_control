import Foundation

struct URLSessionEngine: APIRequesting {
    private let dispatcher: RequestDispatching
    private let completionQueue: DispatchQueue

    init(dispatcher: RequestDispatching = HTTPRequestDispatcher(),
         completionQueue: DispatchQueue) {
        self.dispatcher = dispatcher
        self.completionQueue = completionQueue
    }

    func performRequest<T: Codable, V: APIRouting>(router: V,
                                                   basePath: String,
                                                   configuration: NetworkConfiguration,
                                                   completion: ((Result<T, Error>) -> Void)?) {
        dispatcher.dispatch(router,
                            basePath: basePath,
                            configuration: configuration) { data, error, response in
            guard response?.hasSuccessStatusCode ?? true else {
                return self.call(completion: completion, with: .failure(URLSessionError.general))
            }
            if let error = error {
                return self.handleError(error, completion: completion)
            }
            guard let data = data else {
                return self.call(completion: completion, with: .failure(URLSessionError.invalidData))
            }

            self.handleSuccess(with: data, completion: completion)
        }
    }

    private func handleError<T>(_ error: Error, completion: ((Result<T, Error>) -> Void)?) {
        if (error as? HTTPRequestDispatcherError) == .invalidURL {
            call(completion: completion, with: .failure(URLSessionError.invalidURL))
        } else {
            call(completion: completion, with: .failure(URLSessionError.general))
        }
    }

    private func handleSuccess<T: Codable>(with data: Data, completion: ((Result<T, Error>) -> Void)?) {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            call(completion: completion, with: .success(result))
        } catch {
            call(completion: completion, with: .failure(URLSessionError.encodingFailed))
        }
    }

    private func call<T>(completion: ((Result<T, Error>) -> Void)?, with result: Result<T, Error>) {
        if Thread.isMainThread, completionQueue == .main {
            completion?(result)
        } else {
            completionQueue.async { completion?(result) }
        }
    }
}
