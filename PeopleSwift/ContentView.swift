//
//  ContentView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import SwiftUI




struct ContentView: View {
    
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            }
            else {
                NavigationView {
                    List {
                        ForEach(viewModel.users, id: \.id) { user in
                            
                            /**
                             NavigationLink Can only be used only if our view is in a Navigationview. But has > arrow and right end
                             */
                            
                            /**
                            //NavigationLink with destination and label
                            NavigationLink(destination: UserDetailView(user: user)) {
                                UserInforRowView(name: user.name)
                            }
                            .listRowSeparator(.hidden)
                            **/
                            
                            // THIS WILL REMOVE > arrow and right end
                            UserInforRowView(name: user.name)
                                .background(
                                    NavigationLink("", destination: UserDetailView(user: user))
                                        .opacity(0)
                                )
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Users")
                }
            }
        }
        .task {
            do {
                try await viewModel.fetchUsers()
            }
            catch{
                print("DEBUG: Error occurred while loading user. Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}


