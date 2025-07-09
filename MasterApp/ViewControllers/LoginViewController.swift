//
//  LoginViewController.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 9.7.25..
//

import UIKit

class LoginViewController: UIViewController {

    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        usernameField.placeholder = "Username"
        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none

        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect

        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [usernameField, passwordField, loginButton, errorLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    @objc private func loginTapped() {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""

        if CredentialManager.shared.validate(username: username, password: password) {
            let tabBarController = MainTabBarController()
            UIApplication.shared.windows.first?.rootViewController = tabBarController
        } else {
            errorLabel.text = "Invalid username or password"
        }
    }
}
