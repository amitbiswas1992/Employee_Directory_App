//
//  EmployeeListingCell.swift
//  EmployeeDirectoryApp
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//
//

import UIKit

class EmployeeListingCell: UITableViewCell {

    let imageCache = NSCache<AnyObject, AnyObject>()

    
    @IBOutlet weak var outerView: UIView! {
        didSet {
            outerView.layer.cornerRadius = 10
            outerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var employeeImageOuterView: UIView! {
        didSet {
            employeeImageOuterView.layer.cornerRadius = 35
            employeeImageOuterView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeTeamlabel: UILabel!
    
    
    //MARK: Public Methods
    
    func setData(employee: Employee) {
        if let imageUrl = employee.smallPhoto, let url = URL(string: imageUrl) {
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.employeeImage.image = imageFromCache
                
            } else {
                getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { [weak self] in
                        
                        if let imageToCache = UIImage(data: data) {
                            self?.employeeImage.image = imageToCache
                            self?.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        }
                        self?.employeeImage.image = UIImage(data: data)
                    }
                }
            }
            
        }
        
        employeeNameLabel.text = employee.fullName
        employeeTeamlabel.text = employee.team
        
    }
       
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
