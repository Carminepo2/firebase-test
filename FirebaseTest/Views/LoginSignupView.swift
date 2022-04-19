//
//  LoginSignupView.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 18/04/22.
//

import SwiftUI

struct LoginSignupView: View {
    @StateObject private var viewModel: LoginSignupViewModel
    @Binding var isPushed: Bool
    
    init(mode: LoginSignupViewModel.Mode, isPushed: Binding<Bool>) {
        self._viewModel = .init(
            wrappedValue: LoginSignupViewModel(mode: mode)
        )
        self._isPushed = isPushed
    }
    
    var emailTextField: some View {
        TextField(viewModel.emailPlaceholderText, text: $viewModel.emailText)
            .autocapitalization(.none)
    }
    
    var passwordTextField: some View {
        SecureField(viewModel.passwordPlaceholderText, text: $viewModel.passwordText)
            .autocapitalization(.none)
    }
    
    var actionButton: some View {
        Button(viewModel.buttonTitle) {
            viewModel.tappedActionButton()
        }
        .disabled(!viewModel.isValid)
        .opacity(viewModel.isValid ? 1 : 0.4)
    }
    
    var body: some View {
        VStack {
            Text(viewModel.title)
            Text(viewModel.subtitle)
            
            emailTextField
            passwordTextField
            actionButton
            
        }
        .onReceive(viewModel.$isPushed) { isPushed in
            self.isPushed = isPushed
        }
    }
    
}
