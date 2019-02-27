//
//  SystemInfo.swift
//  RemoteControlPhilips
//
//  Created by Daian Aiziatov on 13/01/2019.
//  Copyright © 2019 Daian Aiziatov. All rights reserved.
//

import Foundation

struct SystemInfo: Decodable {
    
    private(set) var name: String
    var ipAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
}
