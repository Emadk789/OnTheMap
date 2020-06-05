//
//  GetStudentLocationResponse.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 01/06/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var createdAt: String,
        firstName: String,
        lastName: String,
        latitude: Double,
        longitude: Double,
        mapString: String,
        mediaURL: String,
        objectId: String,
        uniqueKey: String,
        updatedAt: String
}
struct GetStudentLocationResponse: Codable {
//    let results: [[String: StudentLocation]];
    let results: [StudentLocation];
}
