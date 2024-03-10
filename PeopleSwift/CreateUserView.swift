//
//  CreateUserView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 10/03/2024.
//

import SwiftUI

struct CreateUserView: View {
    @StateObject var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.isLoading {
                ProgressView()
            }
            else {
                Button{
                    Task{try? await viewModel.createUser()}
                } label: {
                    Text("Create user").frame(width: 270)
                }
                .buttonStyle(.borderedProminent)
            }
            

        }
    }
}

#Preview {
    CreateUserView()
}
