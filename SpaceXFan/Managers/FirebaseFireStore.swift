//
//  FBFireStore.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import Foundation
import FirebaseFirestore

enum NetworkError: Error {
    case fail
}

class FirebaseFireStore {

    static let shared = FirebaseFireStore()
    private var db = Firestore.firestore()
    var favorite: [String]?

    func geData(with userId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        print("User Furkan  \(userId)")

        let docRef = db.collection("Favorite").document(userId)

        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                guard let dataDescription = document.data() else { return }

                self?.favorite = dataDescription["names"] as? [String]

                print(self?.favorite as Any)
                print("Document data: \(dataDescription)")
                completion(.success(true))
            } else {
                print("Document does not exist")
                completion(.failure(NetworkError.fail))
            }
        }
    }

    func setData(with data: String, for userId: String) {
        let document = db.collection("Favorite").document(userId)
        favorite?.append(data)
        document.updateData([
            "names": FieldValue.arrayUnion([data])
        ])

        NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("FavoriteTab"), object: nil)
    }

    func deleteData(with data: String, for userId: String) {
        let document = db.collection("Favorite").document(userId)

        favorite = favorite?.filter {$0 != data}

        document.updateData([
            "names": FieldValue.arrayRemove([data])
        ])

        NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("FavoriteTab"), object: nil)
    }
}
