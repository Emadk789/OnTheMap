//
//  LoginResponse.swift
//  onTheMap
//
//  Created by Emad Albarnawi on 31/05/2020.
//  Copyright © 2020 Emad Albarnawi. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool;
    let key: String
}
struct Session: Codable {
    let id: String;
    let expiration: String;
}
struct LoginResponse: Codable {
    let account: Account;
    let session: Session;
}


