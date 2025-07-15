//
//  SettingViewController.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import UIKit

class SettingsViewController: UIViewController {

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["UIKit", "SwiftUI"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupActions()

        let username = UserDefaults.standard.string(forKey: "loggedInUsername") ?? "Guest"
        greetingLabel.text = "User: \(username)"
        segmentedControl.selectedSegmentIndex = UIStyleSwitcher.currentStyle == .uikit ? 0 : 1
    }

    private func setupUI() {
        view.addSubview(greetingLabel)
        view.addSubview(segmentedControl)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 40),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            logoutButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(styleChanged), for: .valueChanged)
        logoutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }

    @objc private func styleChanged() {
        UIStyleSwitcher.currentStyle = segmentedControl.selectedSegmentIndex == 0 ? .uikit : .swiftui
        UIApplication.shared.windows.first?.rootViewController = MainTabBarController()
    }

    @objc private func logOutTapped() {
        // Clear stored user session
        UserDefaults.standard.removeObject(forKey: "loggedInUsername")
        
        // Reset to login screen
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = LoginViewController()
            window.makeKeyAndVisible()
        }
    }
}
