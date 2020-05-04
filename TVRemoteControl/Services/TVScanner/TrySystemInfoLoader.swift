import Foundation

struct TrySystemInfoLoader: TrySystemInfoLoading {
    private var session: URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 20.0
        let session = URLSession(configuration: sessionConfig)
        return session
    }

    func tryLoadSystemInfo(for ipAddress: String, completion: @escaping (Result<SystemInfo, DataResponseError>) -> Void) {
        let urlRequest = URLRequest(url: baseUrl(for: ipAddress)
            .appendingPathComponent(APIRequest.systemNamePath))
        var encodedURLRequest = urlRequest.encode(with: nil)
        encodedURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: encodedURLRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data else {
                completion(Result.failure(DataResponseError.network))
                return
            }

            guard var systemInfo = try? JSONDecoder().decode(SystemInfo.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }

            systemInfo.ipAddress = ipAddress
            completion(Result.success(systemInfo))
        }

        task.resume()
    }

    private func baseUrl(for ipAddress: String) -> URL {
        let URLString = "http://\(ipAddress):1925"
        guard let url = URL(string: URLString) else {
            fatalError("URL can't be nil")
        }
        return url
    }
}
