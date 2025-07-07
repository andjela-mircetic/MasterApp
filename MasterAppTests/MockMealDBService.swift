//
//  MockMealDBService.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 7.7.25..
//

import Foundation

final class MockMealDBService: MealDBServiceProtocol {
    func fetchRandomRecipes(count: Int) async throws -> [Recipe] {
        return [Recipe(idMeal: "1", strMeal: "recipe1", strCategory: nil, strMealThumb: nil)]
    }
    
    func fetchMealDetail(id: String) async throws -> MealDetail? {
        return nil
    }
    
    func fetchCategories() async throws -> [Category] {
        return [Category(strCategory: "Mock Category")]
    }

    func searchRecipes(query: String) async throws -> [Recipe] {
        return [Recipe(idMeal: "1", strMeal: "Mock meal", strCategory: "italian", strMealThumb: nil)]
    }

    func fetchRecipesByCategory(_ category: String) async throws -> [Recipe] {
        return [Recipe(idMeal: "2", strMeal: "Mock meal 2", strCategory: "sushi", strMealThumb: nil)]
    }
}
