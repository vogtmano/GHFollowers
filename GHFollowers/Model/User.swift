//
//  User.swift
//  GHFollowers
//
//  Created by Maks Vogtman on 24/04/2024.
//

import Foundation

// During the Network Call, the app takes JSON, converts it into objects that we can use in the app.

// That's why you have to create the Model before making a Network Call - to have those objects prepared. Once you're making a network call, they are there to populate the UI.

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
