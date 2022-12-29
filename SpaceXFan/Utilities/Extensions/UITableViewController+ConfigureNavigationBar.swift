//
//  UITableViewController+ConfigureNavigationBar.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit

extension UIViewController {

    func configureNavigationBar(with title: String) {
        configureNavigationBar(largeTitleColor: .label,
                               backgoundColor: .white,
                               tintColor: .label,
                               title: title,
                               preferredLargeTitle: true)
    }

    private func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
        navBarAppearance.backgroundColor = backgoundColor

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = tintColor
        navigationItem.title = title
    }
}
