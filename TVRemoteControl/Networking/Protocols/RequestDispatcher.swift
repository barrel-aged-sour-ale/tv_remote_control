import Foundation

protocol RequestDispatching {
    typealias RequestDispatcherCompletion = (Data?, Error?, HTTPURLResponse?) -> Void

    func dispatch<T: APIRouting>(_ router: T,
                                 basePath: String,
                                 configuration: NetworkConfiguration,
                                 completion: @escaping RequestDispatcherCompletion)
    func dispatch<T: APIRouting>(_ router: T,
                                 basePath: String,
                                 completion: @escaping RequestDispatcherCompletion)
}

extension RequestDispatching {
    func dispatch<T: APIRouting>(_ router: T,
                                 basePath: String,
                                 completion: @escaping RequestDispatcherCompletion) {
        dispatch(router, basePath: basePath, configuration: NetworkConfiguration.default, completion: completion)
    }
}
