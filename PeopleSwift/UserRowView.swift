//
//  UserView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    var body: some View {
        VStack(alignment: .leading) {
            Text("**Name**: \(user.name)")
            Text("**Email**: \(user.email)")
            Divider()
            Text("**Company**: \(user.company.name)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
        .padding(.horizontal, 4)
    }
}

#Preview {
    UserRowView(user: User.Mock_User)
}
