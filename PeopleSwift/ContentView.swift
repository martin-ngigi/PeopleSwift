//
//  ContentView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import SwiftUI




struct ContentView: View {
    
    @StateObject private var viewModel = UserViewModel()
    
    @State var hasError = false
    @State var error: UserViewModel.UserError?

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(viewModel.users, id: \.id ) { user in
                            UserRowView(user: user)
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Users")
                }

            }
            .task {
               //try? await viewModel.fetchUsersAsyncAwait()
                await execute()
            }
//            .onAppear(perform: viewModel.fetchUsersUsingCombine)
            .alert(isPresented: $hasError, error: error) {
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
    ContentView()
}

private extension ContentView {
    func execute() async {
        do {
            try await viewModel.fetchUsersAsyncAwait()
        }
        catch{
            if let userError = error as? UserViewModel.UserError {
                self.hasError = true
                self.error = userError
            }
        }
    }
}


