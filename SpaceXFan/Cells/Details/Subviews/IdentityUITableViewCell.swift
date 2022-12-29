//
//  DetailsIdentityUITableViewCell.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit
import SwiftUI

class IdentityUITableViewCell: UITableViewCell {

    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .regular)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    static let identifier = "DetailsIdentityUITableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        applyConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("IdentityUITableViewCell error")
    }

    override func prepareForReuse() {
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    private func applyConstraints() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    }

    func configure(with rocket: Rockets) {
        descriptionLabel.text = rocket.description

        stackView.addArrangedSubview(descriptionLabel)

        if rocket.upcoming {
            setUpcomingRockets(with: rocket)
        } else {
            setRockets(with: rocket)
        }
    }

    private func setUpcomingRockets(with rocket: Rockets) {
        let active = getLine()
        active.titleLabel.text = "Name"
        active.descriptionLabel.text = String(rocket.name)

        let flight_number = getLine()
        flight_number.titleLabel.text = "Flight Number"
        flight_number.descriptionLabel.text = String(rocket.flight_number)

        let date_utc = getLine()
        date_utc.titleLabel.text = "Date"
        date_utc.descriptionLabel.text = String(rocket.date_utc)

        let upcoming = getLine()
        upcoming.titleLabel.text = "Upcoming"
        upcoming.descriptionLabel.text = String(rocket.upcoming)
    }

    private func setRockets(with rocket: Rockets) {
        let active = getLine()
        active.titleLabel.text = "Active"
        active.descriptionLabel.text = String(rocket.active)

        let boosters = getLine()
        boosters.titleLabel.text = "Boosters"
        boosters.descriptionLabel.text = String(rocket.boosters)

        let cost_per_launch = getLine()
        cost_per_launch.titleLabel.text = "Cost Per Launch"
        cost_per_launch.descriptionLabel.text = String(rocket.cost_per_launch)

        let success_rate_pct = getLine()
        success_rate_pct.titleLabel.text = "Success Rate Pct"
        success_rate_pct.descriptionLabel.text = String(rocket.success_rate_pct)

        let first_flight = getLine()
        first_flight.titleLabel.text = "First Flight"
        first_flight.descriptionLabel.text = rocket.first_flight

        let country = getLine()
        country.titleLabel.text = "Country"
        country.descriptionLabel.text = rocket.country

        let company = getLine()
        company.titleLabel.text = "Company"
        company.descriptionLabel.text = rocket.company

        let height = getLine()
        height.titleLabel.text = "Height"
        height.descriptionLabel.text = String(rocket.height)

        let diameter = getLine()
        diameter.titleLabel.text = "Diameter"
        diameter.descriptionLabel.text = String(rocket.diameter)

        let mass = getLine()
        mass.titleLabel.text = "Mass"
        mass.descriptionLabel.text = String(rocket.mass)
    }

    private func getLine() -> DetailDefinitions {
        let view = DetailDefinitions()
        stackView.addArrangedSubview(view)
        return view
    }
}
