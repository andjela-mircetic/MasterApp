//
//  SettingViewController.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import UIKit

class SettingsViewController: UIViewController {

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["UIKit", "SwiftUI"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        segmentedControl.selectedSegmentIndex = UIStyleSwitcher.currentStyle == .uikit ? 0 : 1
        segmentedControl.addTarget(self, action: #selector(styleChanged), for: .valueChanged)

        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func styleChanged() {
        UIStyleSwitcher.currentStyle = segmentedControl.selectedSegmentIndex == 0 ? .uikit : .swiftui

        // Restart app to apply style change (temporary quick approach)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = MainTabBarController()
        }
    }
}
