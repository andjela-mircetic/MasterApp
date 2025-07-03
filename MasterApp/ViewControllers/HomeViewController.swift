//
//  HomeViewController.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var recipes: [Recipe] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        if UIStyleSwitcher.currentStyle == .swiftui {
            let swiftUIView = HomeSwiftUIView()
            let hostingVC = UIHostingController(rootView: swiftUIView)
            addChild(hostingVC)
            hostingVC.view.frame = view.bounds
            view.addSubview(hostingVC.view)
            hostingVC.didMove(toParent: self)
        } else {
            setupUIKitUI()
            
            tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.reuseIdentifier)
            tableView.separatorStyle = .none
            
            loadRecipes()
        }
    }

    private func setupUIKitUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadRecipes() {
        Task {
            do {
                self.recipes = try await MealDBService.shared.fetchRandomRecipes(count: 20)
                self.tableView.reloadData()
            } catch {
                print("Error fetching recipes: \(error)")
            }
        }
    }

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.reuseIdentifier, for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: recipe)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
