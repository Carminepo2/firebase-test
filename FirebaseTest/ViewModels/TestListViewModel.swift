//
//  TestListViewModel.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 17/04/22.
//

import Foundation
import Combine

final class TestListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let testService: TestServiceProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    @Published private(set) var itemsViewModels: [TestItemViewModel] = []
    @Published private(set) var error: FirebaseTestError?
    @Published private(set) var isLoading = false
    
    enum Action {
        case retry
    }
    
    init(userService: UserServiceProtocol = UserService(), testService: TestServiceProtocol = TestService()) {
        self.userService = userService
        self.testService = testService
        observeTests()
        
    }
    
    func send(action: Action) {
        switch action {
        case .retry:
            observeTests()
        }
    }
    
    private func observeTests() {
        isLoading = true
        userService.currentUserPublisher()
            .compactMap { $0?.uid }
            .flatMap { [weak self] userId -> AnyPublisher<[Test], FirebaseTestError> in
                guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher() }
                return self.testService.observeTests(userId: userId)
            }
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    print("finished")
                }
                
            } receiveValue: { [weak self] tests in
                guard let self = self else { return }
                self.isLoading = false
                self.error = nil
                self.itemsViewModels = tests.map {
                    .init($0) { [weak self] id in
                        self?.deleteTest(id)
                    }
                }
            }.store(in: &cancellables)
    }
    
    private func deleteTest(_ testId: String) {
        testService.delete(testId)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch(completion) {
                case let .failure(error):
                    self.error = error
                case .finished: break
                }
            } receiveValue: { _ in
                self.error = nil
            }
            .store(in: &cancellables)
    }
}
