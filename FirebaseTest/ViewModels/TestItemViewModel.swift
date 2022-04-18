//
//  TestItemViewModel.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 17/04/22.
//

import Foundation

struct TestItemViewModel: Hashable {
    private let test: Test
    
    var number: Int {
        test.number
    }
    
    init(_ test: Test) {
        self.test = test
    }
}
