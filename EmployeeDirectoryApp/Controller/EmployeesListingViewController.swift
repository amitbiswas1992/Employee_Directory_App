//
//  EmployeesListingViewController.swift
//  EmployeeDirectoryApp
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//
//

import UIKit

class EmployeesListingViewController: UIViewController {

    //MARK: Variables and Constants
    
    private let employeeListingNibName = "EmployeeListingCell"
    private let employeeListingCellIdentifier = "employeeListingCellIdentifier"

    private var employeesList = [Employee]()
    
    private var indicator: UIActivityIndicatorView!
    
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.backgroundColor = UIColor.clear
            tableView.separatorColor = .clear
        }
    }
    
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.backgroundColor = .clear
            emptyView.isHidden = true
            
            
        }
    }
    
    
    
    //MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        setupRefreshControl()
        fetchEmployeesList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
    }
    
}


//MARK: Api Calls

extension EmployeesListingViewController {
    
    private func fetchEmployeesList() {
        
        self.indicator.startAnimating()
        
        NetworkManager.shared.getEmployeesList(
            completed: { (result: EmployeesListResult) in
                switch result {
                case .success(let list):
                    
                    DispatchQueue.main.async {
                        for employee in list {
                            if let name = employee.fullName, !name.isEmpty,
                                let uid = employee.uuid, !uid.isEmpty,
                                let email = employee.email, !email.isEmpty,
                                let team = employee.team, !team.isEmpty,
                                let type = employee.employeeType, !type.isEmpty {
                                
                                self.employeesList.append(employee)
                            }
                        }
                        
                        self.employeesList.sort(by: { $0.fullName ?? "" > $1.fullName ?? "" })
                        
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                        self.showEmptyViewIfRequired()
                    }
                    
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                        self.showEmptyViewIfRequired()
                        
                        //Showing Error Message
                        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }

                }
        })
    }
    
}

extension EmployeesListingViewController {
    
    private func setupRefreshControl() {
        indicator = UIActivityIndicatorView(style: .large)
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
    }
    
    private func registerNib() {
        let nib = UINib(nibName: employeeListingNibName, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: employeeListingCellIdentifier)
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.title = "Employees List"
        
    }
    
    private func showEmptyViewIfRequired() {
        self.emptyView.isHidden = self.employeesList.count != 0
    }
    
    private func openEmployeeDetailViewController(employee: Employee) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "employeeDetailViewController") as? EmployeeDetailViewController {
            
            viewController.employee = employee
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
}

//MARK: - UITableView Delegate

extension EmployeesListingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openEmployeeDetailViewController(employee: self.employeesList[indexPath.row])
    }
}

//MARK: - Table View Data Source
extension EmployeesListingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeListingCellIdentifier, for: indexPath) as! EmployeeListingCell
        cell.setData(employee: employeesList[indexPath.row])
        cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeesList.count
        
    }
}
