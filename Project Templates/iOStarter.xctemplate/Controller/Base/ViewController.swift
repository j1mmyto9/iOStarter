//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by Project Xcode Templates
//  Created by Wahyu Ady Prasetyo,
//

import UIKit

class ViewController: UIViewController {
    
    var fields: [UITextField] {
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMethod()
        setupView()
    }
    
    /// Setup add function/ action in object (ex: add button action, add delegate, add gesture)
    func setupMethod() {
        UITextField.connect(fields: fields)
    }
    
    func setupView() {
    }
    
    @objc func fetch() {
        
    }
}
