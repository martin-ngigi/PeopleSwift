//
//  ContentView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import SwiftUI




struct ContentView: View {

    var body: some View {
        TabView{
            UsersListView()
                .tabItem {
                    Label("Users List", systemImage: "person.2")
                }
            
            CreateUserView()
                .tabItem {
                    Label("Create User", systemImage: "person.badge.plus")
                }
        }
    }
}

#Preview {
    ContentView()
}



