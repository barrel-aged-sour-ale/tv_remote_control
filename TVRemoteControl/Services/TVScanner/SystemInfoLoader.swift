//
//  SystemInfoLoader.swift
//  TVRemoteControl
//
//  Created by Daian Aiziatov on 03.05.2020.
//  Copyright © 2020 robot64. All rights reserved.
//

import Foundation

protocol TrySystemInfoLoading {
    func fetchingSystemInfo(completion: @escaping (Result<SystemInfo, DataResponseError>) -> Void)
}
