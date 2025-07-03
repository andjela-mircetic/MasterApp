//
//  FavoritesManager.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 17.6.25..
//

import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    private let key = "favoriteMeals"

    @Published private(set) var favoriteIDs: Set<String> = []
    private var favorites: [Recipe] = []

    private init() {
        self.favorites = loadFavorites()
        self.favoriteIDs = Set(favorites.map { $0.idMeal })
    }

    func getFavorites() -> [Recipe] {
        return favorites
    }

    func add(_ meal: Recipe) {
        guard !favorites.contains(where: { $0.idMeal == meal.idMeal }) else { return }
        favorites.append(meal)
        favoriteIDs.insert(meal.idMeal)
        save(favorites)
        objectWillChange.send()
    }

    func remove(_ meal: Recipe) {
        favorites.removeAll { $0.idMeal == meal.idMeal }
        favoriteIDs.remove(meal.idMeal)
        save(favorites)
        objectWillChange.send()
    }

    func toggleFavorite(_ recipe: Recipe) {
        if isFavorite(recipe) {
            remove(recipe)
        } else {
            add(recipe)
        }
    }

    func isFavorite(_ recipe: Recipe) -> Bool {
        favoriteIDs.contains(recipe.idMeal)
    }

    private func save(_ meals: [Recipe]) {
        if let data = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadFavorites() -> [Recipe] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let meals = try? JSONDecoder().decode([Recipe].self, from: data) else {
            return []
        }
        return meals
    }
}
