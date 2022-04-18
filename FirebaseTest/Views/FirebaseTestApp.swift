//
//  FirebaseTestApp.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 14/04/22.
//

import SwiftUI
import Firebase
import Combine

@main
struct FirebaseTestApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            switch appState.loggedInStatus {
            case .notDetermined:
                LoadingView()
            case .loggedIn:
                TabContainerView()
                    .environmentObject(appState)
            case .loggedOut:
                Text("Not logged")
            }
        }
    }
}


class AppState: ObservableObject {
    @Published private(set) var loggedInStatus: LoggedInStatus = .notDetermined
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    enum LoggedInStatus {
        case notDetermined
        case loggedIn
        case loggedOut
    }
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        userService
            .observeAuthChanges()
            .map { $0 != nil }
            .sink { [weak self] (isLoggedIn: Bool) in
                if isLoggedIn {
                    self?.loggedInStatus = .loggedIn
                } else {
                    self?.loggedInStatus = .loggedOut
                }
            }
            .store(in: &cancellables)
    }
}



struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
             Spacer()
        }
    }
}


