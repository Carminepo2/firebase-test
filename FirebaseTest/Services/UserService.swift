//
//  UserService.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 14/04/22.
//

import Combine
import FirebaseAuth

protocol UserServiceProtocol {
    var currentUser: User? { get }
    func currentUserPublisher() -> AnyPublisher<User?, Never>
    func signInAnonymously() -> AnyPublisher<User, FirebaseTestError>
    func observeAuthChanges() -> AnyPublisher<User?, Never>
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, FirebaseTestError>
    func logout() -> AnyPublisher<Void, FirebaseTestError>
    func login(email: String, password: String) -> AnyPublisher<Void, FirebaseTestError>
}

final class UserService: UserServiceProtocol {
    let currentUser: User? = Auth.auth().currentUser
    
    func currentUserPublisher() -> AnyPublisher<User?, Never> {
        Just(Auth.auth().currentUser).eraseToAnyPublisher()
    }
    
    func signInAnonymously() -> AnyPublisher<User, FirebaseTestError> {
        return Future<User, FirebaseTestError> { promise in
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    return promise(.failure(.auth(description: error.localizedDescription)))
                } else if let user = result?.user {
                    return promise(.success(user))
                }
            }
            
        }.eraseToAnyPublisher()
    }
    
    func observeAuthChanges() -> AnyPublisher<User?, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }
    
    func linkAccount(email: String, password: String) -> AnyPublisher<Void, FirebaseTestError> {
        let emailCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        return Future<Void, FirebaseTestError> { promise in
            Auth.auth().currentUser?.link(with: emailCredential) { result, error in
                if let error = error {
                    return promise(.failure(.default(description: error.localizedDescription)))
                } else if let user = result?.user {
                    Auth.auth().updateCurrentUser(user) { error in
                        if let error = error {
                            return promise(.failure(.default(description: error.localizedDescription)))
                        } else {
                            return promise(.success(() ))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, FirebaseTestError> {
        return Future<Void, FirebaseTestError> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(.default(description: error.localizedDescription)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, FirebaseTestError> {
        return Future<Void, FirebaseTestError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
                
            }
        }
        .eraseToAnyPublisher()
    }
}
