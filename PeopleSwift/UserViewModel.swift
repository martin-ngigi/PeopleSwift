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

    @Published private(set) var isLoading = false
    
    @Published var users: [User] = []
    @Published var hasError = false
    @Published var error: UserError?
    
    private var bag = Set<AnyCancellable>() // import Combine

    
    /**
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
    **/
    
    @MainActor
    func fetchUsersAsyncAwait() async throws {
        do{
            hasError = false
            isLoading =  true
            defer {isLoading = false } // Afetr everything has finished, stop loading
            
            let usersUrlString = "https://jsonplaceholder.typicode.com/userss/"
            //let url = URL(string: usersUrlString)
            guard let url = URL(string: usersUrlString) else {
                print("DEBUG: fetchUsersAsyncAwait Failed to fetch users with due to poorly formatted url:")
                hasError = true
                error = UserError.unKnownError
                //throw UserError.unKnownError
                return
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200  && response.statusCode <= 299 else {
                hasError = true
                error = UserError.invalidStatusCode
                //throw UserError.invalidStatusCode
                return
            }
            
            let decoder = JSONDecoder()
            //let users = try decoder.decode([User].self, from: data)
            guard let users = try? decoder.decode([User].self, from: data) else {
                hasError = true
                error = UserError.failedToDecode
                //throw UserError.failedToDecode
                return
            }
            
            self.users = users
        }
        catch{
            print("DEBUG: fetchUsersAsyncAwait Failed to fetch users with error: \(error.localizedDescription)")
            hasError = true
            self.error = UserError.custom(error: error)
            //throw UserError.custom(error: error)
            return
        }

    }
    
    @MainActor
    func fetchUsersAsyncAwaitSample1() async throws {
        
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
