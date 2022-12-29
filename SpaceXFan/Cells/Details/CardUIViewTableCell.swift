//
//  CardUIViewTableCell.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit

protocol CardUIViewDelegate: AnyObject {
    func tapHeart(_ sender: UIButton, data: String)
}

class CardUIViewTableCell: UITableViewCell {

    lazy var posterImage: UIImageView = {
       let view = UIImageView()

        return view
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 22, weight: .regular)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()

    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .regular)
        view.textAlignment = .left
        view.numberOfLines = 3
        return view
    }()

    lazy var favorite: UIButton = {
        let view = UIButton(type: .custom)

        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        view.addTarget(self, action: #selector(tapHeart), for: .touchUpInside)
        view.backgroundColor = .white
        view.tintColor = .red
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemPink.cgColor
        return view
    }()

    static let identifier = "CardUIViewTableCell"
    weak var delegate: CardUIViewDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        applyConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("IdentityUITableViewCell error")
    }

    override func prepareForReuse() {
    }

    private func applyConstraints() {
        contentView.addSubview(posterImage)
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        posterImage.heightAnchor.constraint(equalToConstant: 200).isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true

        contentView.addSubview(favorite)
        favorite.translatesAutoresizingMaskIntoConstraints = false
        favorite.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 10).isActive = true
        favorite.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        favorite.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favorite.widthAnchor.constraint(equalToConstant: 30).isActive = true

        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }

    func configure(with rocket: Rockets, isFavoriteHidden isHidden: Bool) {
        titleLabel.text = rocket.name
        descriptionLabel.text = rocket.description

        if !rocket.imagesUrl.isEmpty {
            let url = URL(string: rocket.imagesUrl[0])
            posterImage.af.setImage(withURL: url!)
        } else {
            posterImage.image = UIImage(named: "Rocket")
        }

        favorite.isHidden = isHidden
    }

    @objc func tapHeart(_ sender: UIButton) {
        delegate?.tapHeart(sender, data: titleLabel.text!)
    }
}
