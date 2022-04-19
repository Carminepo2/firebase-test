//
//  LandingViewModel.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 18/04/22.
//

import Foundation
import Combine

final class LoginSignupViewModel: ObservableObject {
    private let mode: Mode
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var isValid: Bool = false
    @Published var isPushed = true
    
    private(set) var emailPlaceholderText = "Email"
    private(set) var passwordPlaceholderText = "Password"

    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []

    
    init(
        mode: Mode,
        userService: UserServiceProtocol = UserService()
    ) {
        self.mode = mode
        self.userService = userService
        
        Publishers.CombineLatest($emailText, $passwordText)
            .map { [weak self] email, password in
                return self?.isValidEmail(email) == true && self?.isValidPassword(password) == true
            }
            .assign(to: &$isValid)
    }
    
    var title: String {
        switch mode {
        case .login:
            return "Welcome back"
        case .signup:
            return "Create an account"
        }
    }
    
    var subtitle: String {
        switch mode {
        case .login:
            return "Login with your email"
        case .signup:
            return "Signup via email"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .login:
            return "Log in"
        case .signup:
            return "Sign up"
        }
    }
    
    func tappedActionButton() {
        switch mode {
        case .login:
            userService.login(email: emailText, password: passwordText)
                .sink { completion in
                    switch (completion) {
                    case let .failure(error):
                        print(error.localizedDescription)
                    case .finished: break
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)

        case .signup:
            userService.linkAccount(email: emailText, password: passwordText)
                .sink { [weak self] completion in
                    switch (completion) {
                    case let .failure(error):
                        print(error.localizedDescription)
                    case .finished:
                        print("Finished")
                        self?.isPushed = false
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)

        }
        
    }
}

extension LoginSignupViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) && email.count > 5
    }
    
    func isValidPassword(_ password: String) -> Bool {
        //TODO: Better password validation
        return password.count > 5
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
    }
}
