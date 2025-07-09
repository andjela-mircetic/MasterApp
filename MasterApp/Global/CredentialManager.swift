//
//  CredentialManager.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 9.7.25..
//

import Foundation

class CredentialManager {
    static let shared = CredentialManager()
    private var credentials: [UserCredential] = []

    private init() {
        loadCredentials()
    }

    private func loadCredentials() {
        guard let url = Bundle.main.url(forResource: "credentials", withExtension: "json") else {
            print("credentials.json not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(Credentials.self, from: data)
            credentials = decoded.users
        } catch {
            print("Error loading credentials: \(error)")
        }
    }

    func validate(username: String, password: String) -> Bool {
        credentials.contains(where: { $0.username == username && $0.password == password })
    }
}
