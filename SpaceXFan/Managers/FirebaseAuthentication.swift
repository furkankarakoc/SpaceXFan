//
//  FBAuth.swift
//  SpaceXFan
//
//  Created by Furkan on 28.12.2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuthentication {

    static let shared = FirebaseAuthentication()
    var currentUserId: String = ""
    var isSignedIn: Bool = false

    func signIn(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (res, err) in
            if err != nil {
                print("SignIn fail \(err!.localizedDescription)")
                completion(.failure(NetworkError.fail))
                return
            } else {
                guard let userId = res?.user.uid else { return }
                self?.currentUserId = userId
                self?.isSignedIn = true
                FirebaseFireStore.shared.geData(with: userId) { result in
                    switch(result) {
                    case.success(_):
                        print("getDocument success")
                        // I used NotificationCenter for changes after login
                        NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name("FavoriteTab"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name("refreshSignInButton"), object: nil)
                    case.failure(_):
                        print("getDocument fail")
                    }
                }

                completion(.success(true))
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (res, err) in

            if err != nil {
                print("SignUp fail \(err!.localizedDescription)")
                completion(.failure(NetworkError.fail))
                return
            } else {
                self?.isSignedIn = true
                guard let userId = res?.user.uid else { return }
                self?.currentUserId = userId
                completion(.success(true))
            }
        }
    }

    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            FirebaseFireStore.shared.favorite = []
            completion(.success(true))
        } catch {
            completion(.failure(NetworkError.fail))
        }
    }
}



