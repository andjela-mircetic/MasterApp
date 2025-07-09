//
//  UserCredentials.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 9.7.25..
//

import Foundation

struct UserCredential: Codable {
    let username: String
    let password: String
}

struct Credentials: Codable {
    let users: [UserCredential]
}
