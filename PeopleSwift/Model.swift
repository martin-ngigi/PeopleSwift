//
//  Model.swift
//  PeopleSwift
//
//  Created by Martin Wainaina on 26/01/2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let address: Address
    let phone: String
    let email: String
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

extension User {
    static let Mock_User = User(
        id: 1,
        name: "John Doe",
        username: "jonh_doe",
        address: Address(
            street: "Moi Avenue",
            suite: "!st Park",
            city: "Nairobi",
            zipcode: "0938",
            geo: Geo(
                lat: "37.3159",
                lng: "81.1496"
            )
        ),
        phone: "0712345678",
        email: "wincere@april.biz",
        website: "web.com",
        company: Company(
            name: "Romaguera-Crona",
            catchPhrase: "ulti-layered client-server neural-net",
            bs: "harness real-time e-markets"
        )
    )
}
