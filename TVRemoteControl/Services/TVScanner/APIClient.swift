import Foundation

final class APIClient {

    var ipAddress: String

    private lazy var baseURL: URL = {
        let URLString = "http://\(self.ipAddress):1925"
        return URL(string: URLString)!
    }()

    private(set) lazy var session: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 20.0
        let session = URLSession(configuration: sessionConfig)
        return session
    }()

    init(ipAddress: String) {
        self.ipAddress = ipAddress
    }

    func fetchingSystemInfo(completion: @escaping (Result<SystemInfo, DataResponseError>) -> Void) {
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(APIRequest.systemNamePath))
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

            systemInfo.ipAddress = self.ipAddress
            completion(Result.success(systemInfo))
        }

        task.resume()
    }

}
