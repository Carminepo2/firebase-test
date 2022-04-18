//
//  CreateListView.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 14/04/22.
//

import SwiftUI
import Firebase

struct CreateListView: View {
    @StateObject var viewModel = TestViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button { viewModel.send(action: .createTest) } label: {
                    Text("Create Test")
                }
                .buttonStyle(.plain)
            }
        }
        .alert(isPresented: .constant($viewModel.error.wrappedValue != nil)) {
            Alert(
                title: Text("Error!"),
                message:
                    Text($viewModel.error.wrappedValue?.localizedDescription ?? ""),
                dismissButton: .default(Text("OK"), action: {
                    viewModel.error = nil
                })
            )
        }
    }
    
}
