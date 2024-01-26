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
                            VStack {
                                Text(user.name)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                .gray.opacity(0.1),
                                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                            )
                            .listStyle(.plain)
                            .navigationTitle("Users")
                        }
                    }
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


