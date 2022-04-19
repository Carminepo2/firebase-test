//
//  TestService.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 14/04/22.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TestServiceProtocol {
    func observeTests(userId: UserId) -> AnyPublisher<[Test], FirebaseTestError>
    func create(_ test: Test) -> AnyPublisher<Void, FirebaseTestError>
    func delete(_ testId: String) -> AnyPublisher<Void, FirebaseTestError>
    func updateTest(_ testId: String, number: Int) -> AnyPublisher<Void, FirebaseTestError>
}

final class TestService: TestServiceProtocol {
    private let db = Firestore.firestore()
    
    func observeTests(userId: UserId) -> AnyPublisher<[Test], FirebaseTestError> {
        let query = db.collection("tests")
            .whereField("userId", isEqualTo: userId)
            .order(by: "created", descending: true)
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[Test], FirebaseTestError> in
                do {
                    let challanges = try snapshot.documents.compactMap {
                        try $0.data(as: Test.self)
                    }
                    return Just(challanges)
                        .setFailureType(to: FirebaseTestError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func create(_ test: Test) -> AnyPublisher<Void, FirebaseTestError> {
        return Future<Void, FirebaseTestError> { promise in
            do {
                _ = try self.db.collection("tests").addDocument(from: test) { error in
                    if let error = error {
                        promise(.failure(.default(description: error.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(.default()))
            }
        }.eraseToAnyPublisher()
    }
        
    func delete(_ testId: String) -> AnyPublisher<Void, FirebaseTestError> {
        return Future<Void, FirebaseTestError> { promise in
            self.db.collection("tests").document(testId).delete { error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
            
        }.eraseToAnyPublisher()
    }
    
    func updateTest(_ testId: String, number: Int) -> AnyPublisher<Void, FirebaseTestError> {
        return Future<Void, FirebaseTestError> { promise in
            self.db.collection("tests").document(testId).updateData(
                [
                    "number": number
                ]
            ) { error in
                if let error = error {
                    promise(.failure(.default(description: error.localizedDescription)))
                } else {
                    promise(.success(()))
                }
            }
            
        }.eraseToAnyPublisher()
    }
}
