//
//  ErrorResponse.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 31/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int;
    let error: String;
    
    
}
extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error;
    }
}
