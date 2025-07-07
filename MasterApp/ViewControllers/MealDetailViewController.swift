//
//  MealDetailViewController.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 6.7.25..
//

import UIKit

class MealDetailViewController: UIViewController {

    private let mealID: String
    private var meal: MealDetail?

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    init(mealID: String) {
        self.mealID = mealID
        super.init(nibName: nil, bundle: nil)
        self.title = "Meal Details"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        loadMeal()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func loadMeal() {
        Task {
            do {
                self.meal = try await MealDBService.shared.fetchMealDetail(id: mealID)
                DispatchQueue.main.async {
                    self.populateView()
                }
            } catch {
                print("Failed to load meal: \(error)")
            }
        }
    }

    private func populateView() {
        guard let meal = meal else { return }

        if let imageUrlString = meal.strMealThumb, let url = URL(string: imageUrlString) {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.load(from: url)
            contentStack.addArrangedSubview(imageView)
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }

        let titleLabel = UILabel()
        titleLabel.text = meal.strMeal
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        contentStack.addArrangedSubview(titleLabel)

        if let category = meal.strCategory, let area = meal.strArea {
            let metaLabel = UILabel()
            metaLabel.text = "\(category) • \(area)"
            metaLabel.textColor = .secondaryLabel
            metaLabel.font = .systemFont(ofSize: 16)
            contentStack.addArrangedSubview(metaLabel)
        }

        if let tags = meal.strTags {
            let tagsLabel = UILabel()
            tagsLabel.text = "Tags: \(tags)"
            tagsLabel.font = .italicSystemFont(ofSize: 14)
            tagsLabel.textColor = .gray
            contentStack.addArrangedSubview(tagsLabel)
        }

        let ingredientsLabel = UILabel()
        ingredientsLabel.text = "Ingredients"
        ingredientsLabel.font = .boldSystemFont(ofSize: 18)
        contentStack.addArrangedSubview(ingredientsLabel)

//        let ingredientsList = UILabel()
//        ingredientsList.font = .systemFont(ofSize: 16)
//        ingredientsList.numberOfLines = 0
//        ingredientsList.text = extractIngredients(from: meal)
//            .map { "• \($0.0) - \($0.1)" }
//            .joined(separator: "\n")
//        contentStack.addArrangedSubview(ingredientsList)

        let instructionsLabel = UILabel()
        instructionsLabel.text = "Instructions"
        instructionsLabel.font = .boldSystemFont(ofSize: 18)
        contentStack.addArrangedSubview(instructionsLabel)

        let instructionsText = UILabel()
        instructionsText.text = meal.strInstructions
        instructionsText.numberOfLines = 0
        instructionsText.font = .systemFont(ofSize: 16)
        contentStack.addArrangedSubview(instructionsText)

        if let youtube = meal.strYoutube, let url = URL(string: youtube) {
            let button = UIButton(type: .system)
            button.setTitle("Watch on YouTube", for: .normal)
            button.addAction(UIAction { _ in
                UIApplication.shared.open(url)
            }, for: .touchUpInside)
            contentStack.addArrangedSubview(button)
        }

        if let source = meal.strSource, let url = URL(string: source) {
            let button = UIButton(type: .system)
            button.setTitle("Original Source", for: .normal)
            button.addAction(UIAction { _ in
                UIApplication.shared.open(url)
            }, for: .touchUpInside)
            contentStack.addArrangedSubview(button)
        }
    }

//    private func extractIngredients(from meal: MealDetail) -> [(String, String)] {
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

extension UIImageView {
    func load(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
