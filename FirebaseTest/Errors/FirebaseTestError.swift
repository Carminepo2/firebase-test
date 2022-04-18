//
//  FirebaseTestError.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 15/04/22.
//

import Foundation

enum FirebaseTestError: LocalizedError {
case auth(description: String)
case `default`(description: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case let .auth(description):
            return description
        case let .default(description):
            return description ?? "Something went wrong"
        }
    }
    
}
