//
//  ContentView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import SwiftUI

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

struct Address: Codable{
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Company: Codable{
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Geo: Codable{
    let lat: String
    let lng: String
}

struct ContentView: View {
    
    @State private var users: [User] = []
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            else {
                NavigationView {
                    List {
                        ForEach(users, id: \.id) { user in
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
            isLoading = true
            defer {isLoading = false }
            do {
                self.users = try await fetchUsers()
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

private extension ContentView {
    func fetchUsers() async throws -> [User] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/users/")!)
        let decoder = JSONDecoder()
        return try decoder.decode([User].self, from: data)
    }
}
