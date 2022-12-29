//
//  DetailsLineDefinition.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import Foundation
import UIKit


class DetailDefinitions: UIView {

    lazy var titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.text = "title"
        return lbl
    }()

    lazy var descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.textAlignment = .right
        lbl.numberOfLines = 1
        lbl.sizeToFit()
        lbl.text = "descriptionLabel"
        return lbl
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("IdentityUITableViewCell error")
    }

    private func applyConstraints() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }

}
