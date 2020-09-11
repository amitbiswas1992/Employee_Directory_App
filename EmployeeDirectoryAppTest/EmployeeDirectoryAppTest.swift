//
//  EmployeeDirectoryAppTest.swift
//  EmployeeDirectoryAppTest
//
//  Created by Amit Biswas on 9/8/20.
//  Copyright © 2020 Amit Biswas. All rights reserved.
//
//

import XCTest

@testable import EmployeeDirectoryApp

class EmployeeDirectoryAppTest: XCTestCase {
    
    var viewControllerUnderTest: EmployeesListingViewController?
    
    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "employeeListingViewController") as? EmployeesListingViewController
        
        self.viewControllerUnderTest?.loadView()
        self.viewControllerUnderTest?.viewDidLoad()
    }

    override func tearDown() {
        super.tearDown()
    }

    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView)
    }

    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView.delegate)
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest?.tableView.dataSource)
    }
    
    func testHasAEmptyView() {
        XCTAssertNotNil(viewControllerUnderTest?.emptyView)
    }
    
    
}
