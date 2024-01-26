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
//            .onAppear(perform: {
//                Task{  try await viewModel.fetchUsersAsyncAwait() }
//            })
            .onAppear(perform: viewModel.fetchUsersUsingCombine)
            .alert(isPresented: $viewModel.hasError, error: viewModel.error) {
                Button(action: viewModel.fetchUsersUsingCombine){
                    Text("Retry")
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}


