//
//  UsersListView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 10/03/2024.
//

import SwiftUI

struct UsersListView: View {
    
//    @State var hasError = false
//    @State var error: UserViewModel.UserError?
    
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(viewModel.users, id: \.id ) { user in
//                            UserRowView(user: user)
                            
                            // THIS WILL REMOVE > arrow and right end
                            UserRowView(user: user)
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
            .task {
               try? await viewModel.fetchUsersAsyncAwait()
//                await execute()
            }
//            .onAppear(perform: viewModel.fetchUsersUsingCombine)
            .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                Button{
//                    viewModel.fetchUsersUsingCombine
                    Task {try await viewModel.fetchUsersAsyncAwait() }
                } label: {
                    Text("Retry")
                }
            }
            
        }
    }
}

#Preview {
    UsersListView()
}

private extension UsersListView {
    func execute() async {
        do {
            try await viewModel.fetchUsersAsyncAwait()
        }
        catch{
//            if let userError = error as? UserViewModel.UserError {
//                self.hasError = true
//                self.error = userError
//            }
        }
    }
}

