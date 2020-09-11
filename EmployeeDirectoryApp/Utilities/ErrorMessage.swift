//
//  ErrorMessage.swift
//  EmployeeDirectoryApp
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//
//

import Foundation

enum EDError: String, Error {
    case invalidURL    = "This url is not valid"
    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete request, please check your internet connection"
    case invalidResponse = "Invalid respond from the server. Please try again."
    case invalidData = "The data recieved from the server was invalid"
    
}
