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
        
        let spaceXvc = SpaceXRockets()
        spaceXvc.viewModel = SpaceXRocketsVM()
        let vc1 = UINavigationController(rootViewController: spaceXvc)
        
        let favoriteRvc = FavoriteRockets()
        favoriteRvc.viewModel = FavRocketVM()
        let vc2 = UINavigationController(rootViewController: favoriteRvc)
        
        let upcomingRvc = UpcomingRockets()
        upcomingRvc.viewModel = UpcomingLaunchesVM()
        let vc3 = UINavigationController(rootViewController: upcomingRvc)

        vc1.tabBarItem.image = UIImage(named: "rocketTabBar")
        vc2.tabBarItem.image = UIImage(named: "favTabBar")
        vc3.tabBarItem.image = UIImage(named: "upcomings")

        vc1.title = "Home"
        vc2.title = "Favorites"
        vc3.title = "Upcomings"

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

