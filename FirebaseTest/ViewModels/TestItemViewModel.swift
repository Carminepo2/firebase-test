//
//  TestItemViewModel.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 17/04/22.
//

import Foundation

struct TestItemViewModel: Identifiable {
    private let test: Test
    
    var id: String {
        test.id!
    }
    
    var number: Int {
        test.number
    }
    
    enum Action {
        case delete

    }
    
    private let onDelete: (String) -> Void
    
    init(_ test: Test, onDelete:  @escaping (String) -> Void) {
        self.test = test
        self.onDelete = onDelete
    }
    
    func send(action: Action) {
        guard let id = test.id else { return }
        switch(action) {
        case .delete:
            onDelete(id)
        }
    }
}
