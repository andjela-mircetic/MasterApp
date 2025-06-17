//
//  FavoritesManager.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 17.6.25..
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favoriteMeals"
    private var favorites: [Recipe] = []
    
    private init() {}

    func getFavorites() -> [Recipe] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let meals = try? JSONDecoder().decode([Recipe].self, from: data) else {
            return []
        }
        return meals
    }

    func add(_ meal: Recipe) {
        var current = getFavorites()
        guard !current.contains(where: { $0.idMeal == meal.idMeal }) else { return }
        current.append(meal)
        save(current)
    }

    func remove(_ meal: Recipe) {
        var current = getFavorites()
        current.removeAll { $0.idMeal == meal.idMeal }
        save(current)
    }

    func isFavorite(_ meal: Recipe) -> Bool {
        getFavorites().contains(where: { $0.idMeal == meal.idMeal })
    }

    private func save(_ meals: [Recipe]) {
        if let data = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func toggleFavorite(_ meal: Recipe) {
         if let index = favorites.firstIndex(where: { $0.idMeal == meal.idMeal }) {
             favorites.remove(at: index)
         } else {
             favorites.append(meal)
         }
        save(favorites)
     }
}
