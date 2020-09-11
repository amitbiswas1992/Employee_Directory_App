//
//  Employee.swift
//  EmployeeDirectoryApp
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//
//

import Foundation

struct Employee: Codable {
    
    var uuid: String?
    var fullName: String?
    var phoneNumber: String?
    var email: String?
    var biography: String?
    var smallPhoto: String?
    var largePhoto: String?
    var team: String?
    var employeeType: String?
}

enum CodingKeys: String, CodingKey {
    case fullName = "full_name"
    case phoneNumber = "phone_number"
    case email = "email_address"
    case employeeType = "employee_type"
    case smallPhoto = "photo_url_small"
    case largePhoto = "photo_url_large"
}
