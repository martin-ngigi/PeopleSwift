//
//  UserViewModel.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    
    //private(set) will make sure we can ONLY write while within UserViewModel, but we can read them outside UserViewModel
    //@Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    
    @Published var users: [User] = []
    @Published var hasError = false
    @Published var error: UserError?
    
    private var bag = Set<AnyCancellable>() // intall Combine

    
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

    func fetchUsersUsingCombine() {
        let userUrlString = "https://jsonplaceholder.typicode.com/usersss/"
        
        if let url = URL(string: userUrlString) {
            
            isLoading = true // show loading indicator
            hasError = false
            
            URLSession.shared
                .dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main) // receive data to main thread
                //.map(\.data)
                //.decode(type: [User].self, decoder: JSONDecoder()) // Either use decode or tryMap to decode data
                
                .tryMap({ res in
                    
                    guard let response = res.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else {
                        
                        print("DEBUG: fetchUsersUsingCombine Failed to decode users data with invalid status code of \(res.response)")
                
                        throw UserError.invalidStatusCode
                    }
                    
                    let decoder = JSONDecoder()
                    guard let users = try? decoder.decode([User].self, from: res.data) else {
                        throw UserError.failedToDecode
                    }
                    print("DEBUG: fetchUsersUsingCombine Failed to decode users data")
                    return users
                })
                .sink { response in
                    defer{ self.isLoading = false } // hide loading indicator after completing fetch
                     
                    switch response {
                    case .failure(let error):
                        self.hasError = true
                        self.error = UserError.custom(error: error)
                        print("DEBUG: fetchUsersUsingCombine Failed to fetch users data with error \(error.localizedDescription)")
                    default:
                        break
                    }
                } receiveValue: { [weak self] users in
                    self?.users = users
                }.store(in: &bag)
        }
    }
    
    @MainActor
    func fetchUsersAsyncAwait() async throws {
        
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
        case invalidStatusCode
        case unKnownError
        
        var errorDescription: String? {
            switch self {
            case .custom(let error):
                return error.localizedDescription
            case .failedToDecode:
                return "Failed to decode response."
            case .invalidStatusCode:
                return "Request fails within invalid range"
            case .unKnownError:
                return "Unkwown error has occurred."
            }
            
        }
    }
}
