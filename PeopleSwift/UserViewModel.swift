//
//  UserViewModel.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    
    //private(set) will make sure we can ONLY write while within UserViewModel, but we can read them outside UserViewModel
    //@Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    
    @Published var users: [User] = []
    @Published var hasError = false
    @Published var error: UserError?

    
    func fetchUsers() {
        
        hasError = false// Nothing has gone wrong yet
        isLoading = true
        
        let userURLString = "https://jsonplaceholder.typicode.com/users/"
        if let url = URL(string: userURLString){
            
            URLSession
                .shared
                .dataTask(with: url) {[weak self] data, response, error in
                    
                    DispatchQueue.main.sync {
                        if let error = error {
                            // TODO: Handle Error
                            self?.hasError = true // Error has occurred
                            self?.error = UserError.custom(error: error) // Set the error
                            return
                        }
                        
                        let decoder = JSONDecoder() // Convert from json object to swift object
                        decoder.keyDecodingStrategy = .convertFromSnakeCase // Handle properties that look like first_name -> firstName
                        
                        if let data = data,
                           let users = try? decoder.decode([User].self, from: data){
                            // TODO: Handle setting data
                            self?.users = users
                            
                        }
                        else {
                            // TODO: Handle Decode Error
                            self?.hasError = true
                            self?.error = UserError.failedToDecode
                        }
                        
                        self?.isLoading = false
                    }

                }.resume()
        }
    }

    
    @MainActor
    func fetchUsersSample2() async throws {
        
        isLoading = true // when fetchUsers is called, show fetchUsers
        defer { isLoading = false }// after fetching users, stop showing loader
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://jsonplaceholder.typicode.com/users/")!)
        let decoder = JSONDecoder()
        self.users = try decoder.decode([User].self, from: data)
    }
}

extension UserViewModel{
    enum UserError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case unKnownError
        
        var errorDescription: String? {
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response."
            case .unKnownError:
                return "Unkwown error has occurred."
            }
            
        }
    }
}
