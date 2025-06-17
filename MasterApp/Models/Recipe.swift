//
//  Recipe.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 16.6.25..
//

import Foundation

struct Recipe: Decodable, Encodable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strMealThumb: String?
}

struct RandomRecipesResponse: Decodable {
    let meals: [Recipe]
}
