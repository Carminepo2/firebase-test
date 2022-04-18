//
//  LoginSignupView.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 18/04/22.
//

import SwiftUI

struct LoginSignupView: View {
    @ObservedObject private var viewModel: LoginSignupViewModel
    
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
    }
    
}
