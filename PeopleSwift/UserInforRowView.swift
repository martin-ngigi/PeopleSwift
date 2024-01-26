//
//  UserInforRowView.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import SwiftUI

struct UserInforRowView: View {
    
    let name: String
    
    var body: some View {
        VStack {
            Text(name)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            .gray.opacity(0.1),
            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
        .listRowSeparator(.hidden)
    }
}

#Preview {
    UserInforRowView(name: "Joh Doe")
}
