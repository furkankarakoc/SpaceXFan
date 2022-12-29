//
//  Rocket.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import Foundation
import SwiftyJSON

struct Rockets {
    let name: String
    let type: String
    let active: Bool
    let boosters: Int
    let cost_per_launch: Int
    let success_rate_pct: Int
    let first_flight: String
    let country: String
    let company: String
    let description: String

    let height: Float
    let diameter: Float
    let mass: Int

    let imagesUrl: [String]

    let flight_number: Int
    let date_utc: String
    let upcoming: Bool

    // Default init
    init() {
        self.name = ""
        self.type = ""
        self.active = false
        self.boosters = 0
        self.cost_per_launch = 0
        self.success_rate_pct = 0
        self.first_flight = ""
        self.country = ""
        self.company = ""
        self.description = ""

        self.height = 0
        self.diameter = 0
        self.mass = 0

        self.imagesUrl = []

        self.flight_number = 0
        self.date_utc = ""
        self.upcoming = false
    }

    init(with data: JSON) {

        self.name = data["name"].stringValue
        self.type = data["type"].stringValue
        self.active = data["active"].boolValue
        self.boosters = data["boosters"].intValue
        self.cost_per_launch = data["cost_per_launch"].intValue
        self.success_rate_pct = data["success_rate_pct"].intValue
        self.first_flight = data["first_flight"].stringValue
        self.country = data["country"].stringValue
        self.company = data["company"].stringValue
        self.description = data["description"].stringValue

        self.height = data["height"]["meters"].floatValue
        self.diameter = data["diameter"]["meters"].floatValue
        self.mass = data["mass"]["kg"].intValue

        self.imagesUrl = data["flickr_images"].arrayValue.map({ $0.stringValue })

        self.flight_number = data["flight_number"].intValue
        self.date_utc = data["date_utc"].stringValue
        self.upcoming = data["upcoming"].boolValue
    }
}
