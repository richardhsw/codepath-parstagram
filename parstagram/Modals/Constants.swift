//
//  Constants.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Foundation

enum Errors : String {
    case generalTitle = "Error"
    case emptyUPMessage = "Username and password cannot be empty"
    case loginTitle = "Login Error"
    case loginMessage = "Oops! Something went wrong while logging in:\n"
    case signupTitle = "Sign up error"
    case signupMessage = "Oops! Something went wrong while signing up:\n"
    case emptyCaptionMessage = "Caption cannot be empty"
    case shareTitle = "Sharing Error"
    case shareMessage = "Oops! Something went wrong while sharing your post:\n"
}

enum FormatStrings : String {
    case date = "dd MM yyyy at HH:mm:ss Z"
}

enum HerokuServer : String {
    case appID     = "parstagram"
    case serverURL = "https://rocky-shore-36635.herokuapp.com/parse"
}

enum PostsDB : String {
    case name = "Posts"
    case author
    case caption
    case image
}

enum Segues : String {
    case login = "loginSegue"
    case camera = "showCamera"
}

enum TableViewIdentifiers : String {
    case post = "PostTableViewCell"
    case header = "PostTableViewHeader"
}

enum UserDefaultsKeys : String {
    case isLoggedIn
    case username
    case password
}
