//
//  AddEditFamilyViewController.swift
//  SnoreData
//
//  Created by student1 on 4/2/19.
//  Copyright © 2019 clara. All rights reserved.
//

import UIKit

class AddEditFamilyMemberViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var deleteButton: UIButton!
    
    var familyMember: FamilyMember?
    var familyDelegate: FamilyMemberDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let f = familyMember {
            navigationItem.title = "Edit Family Member"
            nameTextField.text = f.name
            ageTextField.text = "\(f.age)"
            deleteButton.isHidden = false
        }
        
        else {
            navigationItem.title = "Add Family Member"
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let name = nameTextField.text else {
            showAlert(title: "Error", message: "Enter a numerical age")
            return
        }
        
        guard let age = Int16(ageTextField.text!) else {
            showAlert(title:"Error", message: "enter a numerical age")
            return
        }
        
        if age < 0 || age > 130 {
            showAlert(title: "Error", message: "Enter an age between 0 and 130")
            return
        }
        
        if let existingFamilyMember = familyMember {
            existingFamilyMember.age = age
            existingFamilyMember.name = name
            familyDelegate!.modify(familyMember: existingFamilyMember)
        }
        
        else {
            familyDelegate!.newFamilyMember(name: name, age: age)
        }
        
        navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func deleteFamilyMember(_ sender: Any) {
        
        //todo "Are you sure?" Alert dialog
        familyDelegate?.delete(familyMember: familyMember!)
        navigationController!.popViewController(animated: true)
    }
}
