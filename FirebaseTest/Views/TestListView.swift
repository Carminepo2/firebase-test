//
//  TestListView.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 17/04/22.
//

import SwiftUI

struct TestListView: View {
    @StateObject private var viewModel = TestListViewModel()
    var body: some View {
        
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                VStack {
                    Text(error.localizedDescription)
                    Button("Retry") {
                        viewModel.send(action: .retry)
                    }
                }
            } else {
                mainContentView
            }
        }
    }
    
    var mainContentView: some View {
        List {
            ForEach(viewModel.itemsViewModels) { viewModel in
                TestItemView(viewModel: viewModel)
            }
        }
    }
    
}

struct TestListView_Previews: PreviewProvider {
    static var previews: some View {
        TestListView()
    }
}
