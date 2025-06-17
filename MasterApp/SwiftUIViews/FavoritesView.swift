//
//  FavoritesView.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 15.6.25..
//

import SwiftUI

struct FavoritesView: View {
    @State private var favorites: [Recipe] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            if favorites.isEmpty {
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
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(favorites, id: \.idMeal) { meal in
                            VStack(alignment: .trailing) {
                                ZStack(alignment: .topTrailing) {
                                    AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(height: 120)
                                    .clipped()

                                    Button(action: {
                                        FavoritesManager.shared.toggleFavorite(meal)
                                        favorites = FavoritesManager.shared.getFavorites()
                                    }) {
                                        Image(systemName: FavoritesManager.shared.isFavorite(meal) ? "heart.fill" : "heart")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Color.white.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    .padding(6)
                                }

                                Text(meal.strMeal)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding([.horizontal, .bottom], 4)
                            }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }
        //.navigationTitle("Favorites")
        .onAppear {
            favorites = FavoritesManager.shared.getFavorites()
        }
    }
}
