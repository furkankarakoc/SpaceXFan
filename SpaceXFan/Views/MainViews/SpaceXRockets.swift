//
//  AllSpaceXRockets.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit

final class SpaceXRockets: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CardUIViewTableCell.self, forCellReuseIdentifier: CardUIViewTableCell.identifier)
        table.separatorStyle = .none
        return table
    }()

    lazy var userLoginButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Log In", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.setTitle("Log Out", for: .selected)
        view.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
        view.titleLabel?.textColor = .label
        view.titleLabel?.numberOfLines = 0
        return view
    }()
    
    var viewModel: SpaceXRocketsVM?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self


        configureNavigationBar(with: "SpaceX Fan")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userLoginButton)
        loadTableViewCells()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshFavorites),
                                               name: Notification.Name("UserLoggedIn"),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshSignInButton),
                                               name: Notification.Name("refreshSignInButton"),
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func loadTableViewCells() {
        viewModel?.fetchItems(with: Constant.baseUrl + Constant.fetchByRockets) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @objc func tapLogin(_ sender: UIButton) {
        sender.isSelected.toggle()

        if sender.isSelected {
            navigationController?.pushViewController(SignInVC(), animated: true)
        } else {
            FirebaseAuthentication.shared.signOut() { result in
                switch(result) {
                case.success(_):
                    print("signOut success")
                    NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name("FavoriteTab"), object: nil)
                case.failure(_):
                    print("signOut fail")
                }
            }
        }
    }

    @objc func refreshFavorites() {
        tableView.reloadData()
        print("reload")
    }

    @objc func refreshSignInButton() {
        if !userLoginButton.isSelected {
            userLoginButton.isSelected.toggle()
        }
    }
}

extension SpaceXRockets: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getItemCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardUIViewTableCell.identifier, for: indexPath) as? CardUIViewTableCell else {
            return UITableViewCell()
        }
        cell.delegate = self

        guard let item = viewModel?.getItem(at: indexPath.row) else {return UITableViewCell()}

        if let count = FirebaseFireStore.shared.favorite?.filter({ $0 == item.name }).count {
            let isFavorite = count >= 1 ? true : false

            cell.favorite.isSelected = isFavorite
        } else {
            cell.favorite.isSelected = false
        }

        cell.configure(with: item, isFavoriteHidden: false)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsView()

        guard let item = viewModel?.getItem(at: indexPath.row) else {return}
        vc.rocket = item

        if let count = FirebaseFireStore.shared.favorite?.filter({ $0 == item.name }).count {
            let isFavorite = count >= 1 ? true : false
            vc.isFavorite = isFavorite
        }

        navigationController?.pushViewController(vc, animated: true)
    }
}


extension SpaceXRockets: CardUIViewDelegate {
    func tapHeart(_ sender: UIButton, data: String) {

        sender.isSelected.toggle()

        if sender.isSelected {
            if !FirebaseAuthentication.shared.isSignedIn {
                navigationController?.pushViewController(SignInVC(), animated: true)
            } else {
                FirebaseFireStore.shared.setData(with: data, for: FirebaseAuthentication.shared.currentUserId)
            }

        } else {
            FirebaseFireStore.shared.deleteData(with: data, for: FirebaseAuthentication.shared.currentUserId)
        }
    }
}
