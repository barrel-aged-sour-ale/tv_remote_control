import Foundation

protocol TrySystemInfoLoading {
    func tryLoadSystemInfo(for ipAddress: String, completion: @escaping (Result<SystemInfo, DataResponseError>) -> Void)
}
