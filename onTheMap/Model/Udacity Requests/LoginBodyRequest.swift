//
//  LoginBodyRequest.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 31/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation

struct LoginBodyRequest: Codable {
    let username: String;
    let password: String;
}
