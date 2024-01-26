//
//  UserViewModel.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    
    //private(set) will make sure we can ONLY write while within UserViewModel, but we can read them outside UserViewModel
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    
    func fetchUsers() async throws {
        
        isLoading = true // when fetchUsers is called, show fetchUsers
        defer { isLoading = false }// after fetching users, stop showing loader
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/users/")!)
        let decoder = JSONDecoder()
        self.users = try decoder.decode([User].self, from: data)
    }
}
