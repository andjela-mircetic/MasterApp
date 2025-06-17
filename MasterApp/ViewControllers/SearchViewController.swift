//
//  SearchViewController.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import UIKit
import Combine

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let categoryScrollView = UIScrollView()
    private let categoryStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupSearchBar()
        setupCategoryView()
        setupTableView()
        bindViewModel()
        
        Task { await viewModel.fetchCategories() }
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search recipes"
        navigationItem.titleView = searchBar
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCategoryView() {
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.axis = .horizontal
        categoryStack.spacing = 10
        categoryStack.alignment = .center
        
        categoryScrollView.addSubview(categoryStack)
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 50),
            
            categoryStack.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 10),
            categoryStack.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStack.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStack.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStack.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$recipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
        
        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.categoryStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                for category in categories {
                    let button = UIButton(type: .system)
                    button.setTitle(category.strCategory, for: .normal)
                    button.backgroundColor = .systemGray6
                    button.addAction(UIAction { [weak self] _ in
                        Task { await self?.viewModel.searchByCategory(category) }
                    }, for: .touchUpInside)
                    self?.categoryStack.addArrangedSubview(button)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = viewModel.recipes[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = recipe.strMeal
        cell.detailTextLabel?.text = recipe.strCategory ?? ""
        return cell
    }
    
    // MARK: SearchBar

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }
}
