//
//  TestItemView.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 19/04/22.
//

import SwiftUI

struct TestItemView: View {
    private let viewModel: TestItemViewModel
    
    init(viewModel: TestItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text("\(viewModel.number)")
            Spacer()
            Image(systemName: "trash")
                .foregroundColor(.red)
                .onTapGesture {
                    viewModel.send(action: .delete)
                }
        }
    }
}
