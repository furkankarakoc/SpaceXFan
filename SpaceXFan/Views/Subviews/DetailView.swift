//
//  DetailView.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit

final class DetailsView: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(IdentityUITableViewCell.self, forCellReuseIdentifier: IdentityUITableViewCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 600
        return table
    }()


    lazy var favorite: UIButton = {
        let view = UIButton(type: .custom)

        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        view.addTarget(self, action: #selector(tapHeart), for: .touchUpInside)
        view.backgroundColor = .white
        view.tintColor = .black
        view.layer.cornerRadius = 5
        return view
    }()

    var rocket: Rockets?
    var isFavoriteHidden: Bool = false
    var isFavorite: Bool = false
    private var headerView: DetailHeaderView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self



        configureNavigationBar(with: rocket?.name ?? "Details")

        if !isFavoriteHidden {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favorite)
        }

        configureHeaderUIView()

        favorite.isSelected = isFavorite
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func configureHeaderUIView() {
        headerView = DetailHeaderView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: view.bounds.width,
                                                height: 300))
        headerView?.configure(with: rocket?.imagesUrl ?? [])
        tableView.tableHeaderView = headerView
    }

    @objc func tapHeart(_ sender: UIButton) {
        sender.isSelected.toggle()

        if sender.isSelected {
            if !FirebaseAuthentication.shared.isSignedIn {
                navigationController?.pushViewController(SignInVC(), animated: true)
                sender.isSelected.toggle()
            } else {
                FirebaseFireStore.shared.setData(with: rocket?.name ?? "", for: FirebaseAuthentication.shared.currentUserId)
            }

        } else {
            FirebaseFireStore.shared.deleteData(with: rocket?.name ?? "", for: FirebaseAuthentication.shared.currentUserId)
        }
    }
}

extension DetailsView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IdentityUITableViewCell.identifier, for: indexPath) as? IdentityUITableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: rocket!)

        cell.selectionStyle = .none
        return cell
    }
}
