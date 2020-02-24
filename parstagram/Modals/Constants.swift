//
//  Constants.swift
//  parstagram
//
//  Created by Richard Hsu on 2020/2/15.
//  Copyright © 2020 Richard Hsu. All rights reserved.
//

import Foundation

enum Assets : String {
    case defaultProfile = "default_profile"
}

enum CommentsDB : String {
    case name = "Comments"
    case text
    case post
    case author
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
    case queryTitle = "Server Error"
    case queryMessage = "Oops! Something went wrong while retrieving posts:\n"
    case profileTitle = "Updating Profile Error"
    case profileMessage = "Oops! Something went wrong while uploading your new profile picture:\n"
}

enum FormatStrings : String {
    case date = "dd MM yyyy at HH:mm:ss Z"
}

enum HerokuServer : String {
    case appID     = "parstagram"
    case serverURL = "https://rocky-shore-36635.herokuapp.com/parse"
}

enum ImagePickerStrings : String {
    case title = "Choose an Image"
    case camera = "Take Photo"
    case library = "Choose from Library"
    case cancel = "Cancel"
}

enum PostsDB : String {
    case name = "Posts"
    case author
    case caption
    case image
    case createdAt
}

enum StoryboardIDs : String {
    case mainStoryboard = "Main"
    case feedView = "LoggedInTabController"
    case loginView = "LoginViewController"
}

enum Segues : String {
    case login = "loginSegue"
    case camera = "showCamera"
}

enum ReuseIdentifiers : String {
    case feedTable = "PostTableViewCell"
    case feedHeader = "PostTableViewHeader"
    case profileCollection = "PostCollectionViewCell"
}

enum UsersDB : String {
    case username
    case password
    case profileImage
}

enum UserDefaultsKeys : String {
    case isLoggedIn
    case username
    case password
}
