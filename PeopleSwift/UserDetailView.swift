//
//  UserDetailView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import SwiftUI

struct UserDetailView: View {
    
    let user: User
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading) {
                info
                
                Divider()
                
                contact
                
                Divider()
                
                company
                
                Divider()
                
                address
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.gray.opacity(0.1),
                        in: RoundedRectangle(cornerRadius: 10
                                             , style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            )
            .padding()
            .navigationTitle("User Details")
        }
    }
}

#Preview {
    UserDetailView(user: User.Mock_User)
}

private extension UserDetailView {
    
    var info: some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Info")
                .bold()
            Text(user.name)
            Text(user.username)
        }
    }
    
    var contact: some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Contact")
                .bold()
            Text(user.website)
            Text(user.phone)
            Text(user.email)
        }
    }
    
    var company: some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Company")
                .bold()
            Text(user.company.name)
        }
    }
    
    var address: some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Address")
                .bold()
            Text(user.address.street)
            Text(user.address.suite)
            Text(user.address.city)
            Text(user.address.zipcode)
        }
    }
}
