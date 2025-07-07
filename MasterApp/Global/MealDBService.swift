//
//  MealDBService.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 16.6.25..
//

import Foundation

protocol MealDBServiceProtocol {
    func fetchCategories() async throws -> [Category]
    func searchRecipes(query: String) async throws -> [Recipe]
    func fetchRecipesByCategory(_ category: String) async throws -> [Recipe]
    func fetchRandomRecipes(count: Int) async throws -> [Recipe]
    func fetchMealDetail(id: String) async throws -> MealDetail?
}

class MealDBService: MealDBServiceProtocol {
    static var shared: MealDBServiceProtocol = MealDBService()
    private let session = URLSession.shared

    private init() {}

    func fetchRandomRecipes(count: Int = 10) async throws -> [Recipe] {
        var recipes: [Recipe] = []

        for _ in 0..<count {
            let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!
            let (data, _) = try await session.data(from: url)
            let decoded = try JSONDecoder().decode(RandomRecipesResponse.self, from: data)
            recipes.append(contentsOf: decoded.meals)
        }

        return recipes
    }
}

extension MealDBService {

    // Fetch categories list
    func fetchCategories() async throws -> [Category] {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?c=list")!
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(CategoryResponse.self, from: data)
        return decoded.meals
    }
    
    // Search recipes by query
    func searchRecipes(query: String) async throws -> [Recipe] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(encodedQuery)") else {
            return []
        }
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(RandomRecipesResponse.self, from: data)
        return decoded.meals
    }
    
    // Filter recipes by category
    func fetchRecipesByCategory(_ category: String) async throws -> [Recipe] {
        guard let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(encodedCategory)") else {
            return []
        }
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(RandomRecipesResponse.self, from: data)
        return decoded.meals
    }
    
    func fetchMealDetail(id: String) async throws -> MealDetail? {
          let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!
          let (data, _) = try await URLSession.shared.data(from: url)
          let response = try JSONDecoder().decode(MealDetailResponse.self, from: data)
          return response.meals.first
      }
}
