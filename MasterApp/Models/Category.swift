//
//  Category.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 16.6.25..
//


struct CategoryResponse: Decodable {
    let meals: [Category]
}

struct Category: Decodable, Identifiable {
    let strCategory: String
    var id: String { strCategory }
}
