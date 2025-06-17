//
//  HomeView.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import SwiftUI

struct HomeSwiftUIView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        //NavigationView {
            List(viewModel.recipes, id: \.idMeal) { recipe in
                VStack(alignment: .leading) {
                    Text(recipe.strMeal).font(.headline)
                    if let category = recipe.strCategory {
                        Text(category).font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
           // .navigationTitle("Home")
            .task {
                await viewModel.loadRecipes()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
       // }
    }
}
