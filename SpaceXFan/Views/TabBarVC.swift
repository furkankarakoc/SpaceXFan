//
//  TabBarViewController.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit

class TabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: SpaceXRockets())
        let vc2 = UINavigationController(rootViewController: FavoriteRockets())
        let vc3 = UINavigationController(rootViewController: UpcomingRockets())

        vc1.tabBarItem.image = UIImage(systemName: "paperplane")
        vc2.tabBarItem.image = UIImage(systemName: "heart.circle.fill")
        vc3.tabBarItem.image = UIImage(systemName: "scanner.fill")

        vc1.title = "All SpaceX Rockets"
        vc2.title = "Favorite Rockets"
        vc3.title = "Upcoming Launches"

        tabBar.tintColor = .black

        let appearance = tabBar.standardAppearance
        appearance.configureWithDefaultBackground()
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.standardAppearance = appearance
        }

        setViewControllers([vc1, vc2, vc3], animated: true)
    }
}

