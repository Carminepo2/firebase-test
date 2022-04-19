//
//  Test.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 14/04/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Test: Codable, Identifiable {
    @DocumentID var id: String?
    let userId: String
    let number: Int
    let created: Date
}
