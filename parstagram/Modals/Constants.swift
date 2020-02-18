//
//  Constants.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Foundation

enum HerokuServer : String {
    case appID     = "parstagram"
    case serverURL = "https://rocky-shore-36635.herokuapp.com/parse"
}

enum Segues : String {
    case login = "loginSegue"
}

enum TableViewIdentifiers : String {
    case post = "PostTableViewCell"
}

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

enum PostsDB : String {
    case name = "Posts"
    case author
    case caption
    case image
}
