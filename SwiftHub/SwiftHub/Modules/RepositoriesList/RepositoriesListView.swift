//
//  RepositoriesListView.swift
//  SwiftHub
//
//  Created by Emilio Heinzmann on 27/10/20.
//

import SwiftUI

struct RepositoriesListView: View {
    @ObservedObject var viewModel = RespositoriesListViewModel()
    
    init() {
        configNavigationBarAppearence()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.repositories) { repository in
                    NavigationLink(destination: RepositoryDetailView(repository: repository)) {
                        RepositoryListView(repository: repository)
                    }
                }
            }
            .navigationBarTitle("Repositories", displayMode: .large)
        }
        .accentColor(.white)
    }
}

struct RepositoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesListView()
    }
}
