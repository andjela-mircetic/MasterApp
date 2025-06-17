//
//  HomeViewModel.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 16.6.25..
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: String?

    func loadRecipes() async {
        isLoading = true
        error = nil
        do {
            let fetched = try await MealDBService.shared.fetchRandomRecipes(count: 20)
            recipes = fetched
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
