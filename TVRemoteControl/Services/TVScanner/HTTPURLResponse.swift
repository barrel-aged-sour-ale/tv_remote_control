//
//  HTTPURLResponse.swift
//  RemoteControlPhilips
//
//  Created by Daian Aiziatov on 13/01/2019.
//  Copyright © 2019 Daian Aiziatov. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
