//
//  SearchView.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import SwiftUI

struct SearchSwiftUIView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.categories) { category in
                                Button(category.strCategory) {
                                    Task { await viewModel.searchByCategory(category) }
                                }
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(20)
                            }
                        }
                        .padding()
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if viewModel.recipes.isEmpty {
                    Text("No recipes found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.recipes, id: \.idMeal) { recipe in
                        NavigationLink(destination: MealDetailView(mealID: recipe.idMeal)) {
                            VStack(alignment: .leading) {
                                Text(recipe.strMeal)
                                    .font(.headline)
                                
                                if let category = recipe.strCategory {
                                    Text(category)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.query)
            .task {
                await viewModel.fetchCategories()
            }
        }
    }
}

