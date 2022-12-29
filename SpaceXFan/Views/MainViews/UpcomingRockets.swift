//
//  UpcomingLaunches.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import UIKit

final class UpcomingRockets: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CardUIViewTableCell.self, forCellReuseIdentifier: CardUIViewTableCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    var viewModel: UpcomingLaunchesVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        configureNavigationBar(with: "Upcoming Launches")
        loadTableViewCells()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func loadTableViewCells() {
        viewModel?.fetchItems(with: Constant.baseUrl + Constant.fetchByUpcoming) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension UpcomingRockets: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getItemCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardUIViewTableCell.identifier, for: indexPath) as? CardUIViewTableCell else {
            return UITableViewCell()
        }
        
        guard let item = viewModel?.getItem(at: indexPath.row) else  { return UITableViewCell() }
        
        cell.configure(with: item, isFavoriteHidden: true)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsView()
        vc.rocket = viewModel?.getItem(at: indexPath.row)
        vc.isFavoriteHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

