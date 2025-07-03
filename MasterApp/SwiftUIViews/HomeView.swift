//
//  HomeView.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import SwiftUI

struct HomeSwiftUIView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var favoritesManager = FavoritesManager.shared

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.recipes, id: \.idMeal) { recipe in
                        HStack(alignment: .top, spacing: 16) {
                            AsyncImage(url: URL(string: recipe.strMealThumb ?? "")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipped()
                                        .cornerRadius(8)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text(recipe.strMeal)
                                    .font(.headline)

                                if let category = recipe.strCategory {
                                    Text(category)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Button(action: {
                                    favoritesManager.toggleFavorite(recipe)
                                }) {
                                    Image(systemName: favoritesManager.isFavorite(recipe) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Meals")
            .task {
                await viewModel.loadRecipes()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
        }
    }
}
