//
//  NetworkManager.swift
//  EmployeeDirectoryApp
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//
//

import Foundation

typealias EmployeesListResult = Result<[Employee], EDError>

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init(){}
    
    func getEmployeesList(completed: @escaping (_ newsList: Result< [Employee], EDError> ) -> Void) {
        
        let endpoint = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
        
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                
                completed(.failure(.invalidResponse))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    completed(.failure(.invalidData))
                    return
                }
                
                if let array = json["employees"] as? [Any] {
                    var employeesArray = [Employee]()
                    for element in array {
                        
                        if let value = element as? [String:Any] {
                            
                            let data = try JSONSerialization.data(withJSONObject: value, options: [])
                            var employee = try decoder.decode(Employee.self, from: data)
                            
                            employee.email = value["email_address"] as? String
                            employee.smallPhoto = value["photo_url_small"] as? String
                            employee.largePhoto = value["photo_url_large"] as? String
                            
                            employeesArray.append(employee)
                        }
                    }

                    completed(.success(employeesArray))
                }
                
            }
            catch {
                completed(.failure(.invalidResponse))
                return
            }
        }
        
        
        task.resume()
    }
}

