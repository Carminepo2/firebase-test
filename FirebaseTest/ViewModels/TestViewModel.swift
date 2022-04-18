//
//  TestViewModel.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 14/04/22.
//

import SwiftUI
import Combine

typealias UserId = String

final class TestViewModel: ObservableObject {
    
    @Published var error: FirebaseTestError?
    @Published var isLoading = false
    
    private let userService: UserServiceProtocol
    private let testService: TestServiceProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    init(
        userService: UserServiceProtocol = UserService(),
        testService: TestServiceProtocol = TestService()
    ) {
        self.userService = userService
        self.testService = testService
    }
    
    
    enum Action {
        case createTest
    }
    
    func send(action: Action) {
        switch action {
        case .createTest:
            self.isLoading = true
            currentUserId()
                .flatMap { userId -> AnyPublisher<Void, FirebaseTestError> in
                    return self.createTest(userId: userId)
                }
                .sink { completion in
                    self.isLoading = false
                    switch completion {
                    case let .failure(error):
                        self.error = error
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    print("Success")
                }.store(in: &cancellables)

        }
    }
}



// MARK: - Publishers
extension TestViewModel {
    
    private func createTest(userId: UserId) -> AnyPublisher<Void, FirebaseTestError> {
        // Insert validation here
        // guard let .... else {  return Fail(error: .default("Parsing error")).eraseToAnyPublisher()   }
        return testService.create(.init(userId: userId, number: Int.random(in: 1...10))).eraseToAnyPublisher()
    }
    
    private func currentUserId() -> AnyPublisher<UserId, FirebaseTestError> {
        return userService.currentUser()
            .flatMap { user -> AnyPublisher<UserId, FirebaseTestError> in
                if let userId = user?.uid {
                    return Just(userId)
                        .setFailureType(to: FirebaseTestError.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.userService
                        .signInAnonymously()
                        .map { $0.uid }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
