//
//  EmployeeDetailViewController.swift
//  EmployeeDirectoryApp
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//
//

import UIKit

class EmployeeDetailViewController: UIViewController {

    //MARK: Variables
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    var employee = Employee()
    
    
    //MARK: Outlets
    
    @IBOutlet weak var outerView: UIView! {
        didSet {
            outerView.layer.cornerRadius = 10
            outerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var employeeImageOuterView: UIView! {
        didSet {
            employeeImageOuterView.layer.cornerRadius = 50
            employeeImageOuterView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var employeeBiographyLabel: UILabel!
    @IBOutlet weak var employeePhoneNumberLabel: UILabel!
    @IBOutlet weak var employeeEmailLabel: UILabel!
    @IBOutlet weak var employeeTeamLabel: UILabel!
    @IBOutlet weak var employeeImageLabel: UIImageView!
    
    
    //MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        initializeData()
    }
    

}

extension EmployeeDetailViewController {
    
    private func setupNavBar() {
        self.title = "Employee Detail"
        
    }
    
    private func initializeData() {
        
        employeeNameLabel.text = self.employee.fullName
        employeeBiographyLabel.text = self.employee.biography
        employeePhoneNumberLabel.text = self.employee.phoneNumber
        employeeEmailLabel.text = self.employee.email
        employeeTeamLabel.text = self.employee.team
        
        if let imageUrl = employee.smallPhoto, let url = URL(string: imageUrl) {
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.employeeImageLabel.image = imageFromCache
                
            } else {
                getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { [weak self] in
                        
                        if let imageToCache = UIImage(data: data) {
                            self?.employeeImageLabel.image = imageToCache
                            self?.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                        }
                        self?.employeeImageLabel.image = UIImage(data: data)
                    }
                }
            }
            
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
}



   

