//
//  MealDetailView.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 6.7.25..
//

import SwiftUI

struct MealDetailView: View {
    let mealID: String
    @State private var meal: MealDetail?
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            if let meal = meal {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageURL = meal.strMealThumb,
                       let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    Text(meal.strMeal)
                        .font(.title)
                        .bold()

                    HStack {
                        if let category = meal.strCategory {
                            Text(category)
                        }
                        if let area = meal.strArea {
                            Text("• \(area)")
                        }
                    }
                    .foregroundColor(.gray)

                    if let tags = meal.strTags {
                        Text("Tags: \(tags)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    Text("Ingredients")
                        .font(.headline)

//                    ForEach(extractIngredients(from: meal), id: \.0) { ingredient, measure in
//                        Text("• \(ingredient) - \(measure)")
//                    }

                    Divider()

                    Text("Instructions")
                        .font(.headline)
                    Text(meal.strInstructions ?? "No instructions")
                        .font(.body)

                    if let youtube = meal.strYoutube,
                       let url = URL(string: youtube) {
                        Link("Watch on YouTube", destination: url)
                            .foregroundColor(.blue)
                            .padding(.top)
                    }

                    if let source = meal.strSource,
                       let url = URL(string: source) {
                        Link("Original Source", destination: url)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            } else if isLoading {
                ProgressView("Loading meal...")
            } else {
                Text("Failed to load meal.")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Meal Details")
        .task {
            await loadMeal()
        }
    }

    func loadMeal() async {
        isLoading = true
        meal = try? await MealDBService.shared.fetchMealDetail(id: mealID)
        isLoading = false
    }

//    func extractIngredients(from meal: MealDetail) -> [(String, String)] {
//        var result: [(String, String)] = []
//        for i in 1...20 {
//            let ingredientKey = "strIngredient\(i)"
//            let measureKey = "strMeasure\(i)"
//            let ingredient = meal.value(forKey: ingredientKey) as? String
//            let measure = meal.value(forKey: measureKey) as? String
//            if let ing = ingredient?.trimmingCharacters(in: .whitespacesAndNewlines), !ing.isEmpty,
//               let meas = measure?.trimmingCharacters(in: .whitespacesAndNewlines), !meas.isEmpty {
//                result.append((ing, meas))
//            }
//        }
//        return result
//    }
}
