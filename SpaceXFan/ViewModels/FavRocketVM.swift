//
//  FavoriteRocketsViewModel.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

final class FavRocketVM {

    private var items: [Rockets] = []
    private var favorite: [Rockets] = []
    static let shared = FavRocketVM()

    func fetchItems(with urlStr: String, completion: @escaping () -> Void) {

        guard let urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }

        guard let url = URL(string: urlStr) else {
            return
        }

        AF.request(url, method: .get).response { [weak self] payload in

            guard let self = self else {
                return
            }

            switch payload.result {
            case .success(let value):

                let json = JSON(value as Any).arrayValue

                self.unload()
                self.load(with: json)

                completion()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func load(with json: [JSON]) {
        for el in json {
            items.append(Rockets(with: el))
        }
    }

    private func unload() {
        items = []
    }

    func prepareFavorite() {
        favorite = []
        for item in items {
            if let count = FirebaseFireStore.shared.favorite?.filter({ $0 == item.name }).count {
                if count >= 1 {
                    favorite.append(item)
                }
            }
        }
    }

    func getItem(at index: Int) -> Rockets {

        return favorite[index]
    }

    func getItemCount() -> Int {
        return favorite.count
    }
}
