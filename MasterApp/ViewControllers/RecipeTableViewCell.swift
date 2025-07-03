//
//  RecipeTableViewCell.swift
//  MasterApp
//
//  Created by Andjela Mircetic on 18.6.25..
//
import Foundation
import UIKit

class RecipeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RecipeCell"

    private let recipeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private var recipe: Recipe?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)

        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 8
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        categoryLabel.font = .systemFont(ofSize: 14)
        categoryLabel.textColor = .gray
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .red
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, categoryLabel, favoriteButton])
        labelsStack.axis = .vertical
        labelsStack.spacing = 8
        labelsStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(recipeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            recipeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            recipeImageView.widthAnchor.constraint(equalToConstant: 80),
            recipeImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            favoriteButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            favoriteButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
        ])
    }

    func configure(with recipe: Recipe) {
        self.recipe = recipe
        titleLabel.text = recipe.strMeal
        categoryLabel.text = recipe.strCategory

        if let urlString = recipe.strMealThumb, let url = URL(string: urlString) {
            // Basic async loading (or use Kingfisher / SDWebImage)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                }
            }
        } else {
            recipeImageView.image = UIImage(systemName: "photo")
        }

        let isFavorite = FavoritesManager.shared.isFavorite(recipe)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func favoriteTapped() {
        guard let recipe = recipe else { return }
        FavoritesManager.shared.toggleFavorite(recipe)
        configure(with: recipe)
    }
}
