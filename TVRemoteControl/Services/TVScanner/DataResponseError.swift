//
//  DataResponseError.swift
//  RemoteControlPhilips
//
//  Created by Daian Aiziatov on 13/01/2019.
//  Copyright © 2019 Daian Aiziatov. All rights reserved.
//

import Foundation

enum DataResponseError: Error {
    
    case noTVinNetwork
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .noTVinNetwork:
            return "There is no PhilipsTV connected to this network"
        case .network:
            return "An error occurred while fetching data "
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}
