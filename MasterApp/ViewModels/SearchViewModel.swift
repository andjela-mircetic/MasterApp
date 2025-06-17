//
//  SearchViewModel.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 16.6.25..
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var recipes: [Recipe] = []
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                Task { await self?.search(query: query) }
            }
            .store(in: &cancellables)
    }
    
    func fetchCategories() async {
        do {
            categories = try await MealDBService.shared.fetchCategories()
        } catch {
            print(error)
        }
    }
    
    func search(query: String) async {
        guard !query.isEmpty else { recipes = []; return }
        isLoading = true
        do {
            recipes = try await MealDBService.shared.searchRecipes(query: query)
        } catch {
            print(error)
        }
        isLoading = false
    }
    
    func searchByCategory(_ category: Category) async {
        isLoading = true
        query = ""
        do {
            recipes = try await MealDBService.shared.fetchRecipesByCategory(category.strCategory)
        } catch {
            print(error)
        }
        isLoading = false
    }
}
