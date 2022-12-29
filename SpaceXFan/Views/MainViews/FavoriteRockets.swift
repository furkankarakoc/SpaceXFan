//
//  FavoriteRockets.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit

final class FavoriteRockets: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CardUIViewTableCell.self, forCellReuseIdentifier: CardUIViewTableCell.identifier)
        table.separatorStyle = .none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self


        configureNavigationBar(with: "Favorite Rockets")
        loadTableViewCells()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshFavorites),
                                               name: Notification.Name("FavoriteTab"),
                                               object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func checkIfsignIn() {

        if !FirebaseAuthentication.shared.isSignedIn {
            navigationController?.pushViewController(SignInVC(), animated: true)
        }
    }

    private func loadTableViewCells() {
        FavRocketVM.shared.fetchItems(with: Constant.baseUrl + Constant.fetchByRockets) { [weak self] in
            DispatchQueue.main.async {
                FavRocketVM.shared.prepareFavorite()
                self?.tableView.reloadData()
            }
        }
    }

    @objc func refreshFavorites() {
        FavRocketVM.shared.prepareFavorite()
        tableView.reloadData()
        print("reload")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkIfsignIn()

        FavRocketVM.shared.prepareFavorite()
        tableView.reloadData()
    }
}

extension FavoriteRockets: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavRocketVM.shared.getItemCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardUIViewTableCell.identifier, for: indexPath) as? CardUIViewTableCell else {
            return UITableViewCell()
        }
        cell.delegate = self

        let item = FavRocketVM.shared.getItem(at: indexPath.row)
        cell.favorite.isSelected = true

        cell.configure(with: item, isFavoriteHidden: false)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = DetailsView()

        let item = FavRocketVM.shared.getItem(at: indexPath.row)
        vc.rocket = item

        if let count = FirebaseFireStore.shared.favorite?.filter({ $0 == item.name }).count {
            let isFavorite = count >= 1 ? true : false
            vc.isFavorite = isFavorite
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FavoriteRockets: CardUIViewDelegate {
    func tapHeart(_ sender: UIButton, data: String) {

        sender.isSelected.toggle()

        if sender.isSelected {
            if !FirebaseAuthentication.shared.isSignedIn {
                navigationController?.pushViewController(SignInVC(), animated: true)

                if FirebaseAuthentication.shared.isSignedIn {
                    sender.isSelected.toggle()
                }
            } else {
                FirebaseFireStore.shared.setData(with: data, for: FirebaseAuthentication.shared.currentUserId)
            }

        } else {
            FirebaseFireStore.shared.deleteData(with: data, for: FirebaseAuthentication.shared.currentUserId)
        }
    }
}


