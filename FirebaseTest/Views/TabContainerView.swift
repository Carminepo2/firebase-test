//
//  TabContainerView.swift
//  FirebaseTest
//
//  Created by Carmine Porricelli on 17/04/22.
//

import SwiftUI

struct TabContainerView: View {
    @StateObject private var viewModel = TabContainerViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ForEach(viewModel.tabItemViewModels, id: \.self) { viewModel in
                tabView(for: viewModel.type)
                    .tabItem {
                        Image(systemName: viewModel.imageName)
                        Text(viewModel.title)
                    }
                    .tag(viewModel.type )
            }
        }
    }
    
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .create:
            CreateListView()
        case .list:
            TestListView()
        }
    }
}

struct TabContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TabContainerView()
    }
}

final class TabContainerViewModel: ObservableObject {
    
    @Published var selectedTab: TabItemViewModel.TabItemType = .create
    let tabItemViewModels = [
        TabItemViewModel(imageName: "heart", title: "Create", type: .create),
        .init(imageName: "list.bullet", title: "List", type: .list)
    ]
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType
    
    enum TabItemType {
        case create
        case list
    }
}
