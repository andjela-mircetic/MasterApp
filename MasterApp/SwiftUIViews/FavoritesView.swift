//
//  FavoritesView.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import SwiftUI

import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            if favoritesManager.favoriteIDs.isEmpty {
                VStack {
                    Image(systemName: "heart.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)

                    Text("No favorites yet.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(favoritesManager.getFavorites(), id: \.idMeal) { meal in
                            NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                                HStack(alignment: .top, spacing: 16) {
                                    AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { phase in
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
                                        Text(meal.strMeal)
                                            .font(.headline)

                                        if let category = meal.strCategory {
                                            Text(category)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }

                                        Button(action: {
                                            favoritesManager.toggleFavorite(meal)
                                        }) {
                                            Image(systemName: favoritesManager.isFavorite(meal) ? "heart.fill" : "heart")
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .navigationTitle("Favorites")
            }
        }
    }
}
