//
//  SearchViewModelTests.swift
//  SearchViewModelTests
//
//  Created by Andjela Mircetic on 15.6.25..
//

import XCTest
@testable import MasterApp

import Foundation

@MainActor
final class SearchViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MealDBService.shared = MockMealDBService()
    }

    func testInitialState() {
        let viewModel = SearchViewModel()
        
        XCTAssertEqual(viewModel.query, "")
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertTrue(viewModel.categories.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }

//    func testSearchUpdatesRecipes() async {
//        let viewModel = SearchViewModel()
//        await viewModel.search(query: "chicken")
//        
//        XCTAssertFalse(viewModel.recipes.isEmpty)
//        XCTAssertEqual(viewModel.recipes.first?.strMeal, "Mock Chicken")
//    }

//    func testSearchByCategoryClearsQueryAndUpdatesRecipes() async {
//        let viewModel = SearchViewModel()
//        let category = Category(strCategory: "Seafood")
//        
//        await viewModel.searchByCategory(category)
//        
//        XCTAssertEqual(viewModel.query, "")
//        XCTAssertEqual(viewModel.recipes.first?.strMeal, "Mock Fish")
//    }

//    func testFetchCategoriesPopulatesCategories() async {
//        let viewModel = SearchViewModel()
//        await viewModel.fetchCategories()
//        
//        XCTAssertFalse(viewModel.categories.isEmpty)
//        XCTAssertEqual(viewModel.categories.first?.strCategory, "Mock Category")
//    }
}

