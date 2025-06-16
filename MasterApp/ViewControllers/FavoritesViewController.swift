//
//  FavoritesViewController.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import UIKit
import SwiftUI

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground

        if UIStyleSwitcher.currentStyle == .swiftui {
            let swiftUIView = FavoritesSwiftUIView()
            let hostingVC = UIHostingController(rootView: swiftUIView)
            addChild(hostingVC)
            hostingVC.view.frame = view.bounds
            view.addSubview(hostingVC.view)
            hostingVC.didMove(toParent: self)
        } else {
            setupUIKitUI()
        }
    }

    private func setupUIKitUI() {
        let label = UILabel()
        label.text = "Favorites - UIKit"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
