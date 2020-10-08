//
//  ViewController.swift
//  Contact Registration
//
//  Created by Grigor Grigoryan on 10/4/20.
//  Copyright © 2020 Grigor Grigoryan. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactViewControllerDelegate {

    @IBOutlet weak var firstTxf: UITextField!
    @IBOutlet weak var secondTxf: UITextField!
    @IBOutlet weak var lblSuccessCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    var store = CNContactStore()
    var saveRequest = CNSaveRequest()
    
    private func registerContact(number: String) {
        let contact = CNMutableContact()
        // Name
        contact.givenName = "\(number)"
        
        // Phone
        contact.phoneNumbers.append(CNLabeledValue(
            label: "GG", value: CNPhoneNumber(stringValue: number)))
        
        // Save
        saveRequest.add(contact, toContainerWithIdentifier: nil)
    }
    
    private func removeContact(number: String) {

        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: number))
        
        let keys = [CNContactPhoneNumbersKey as CNKeyDescriptor]
        
//        let slectedNumber = CNLabeledValue(label: "GG", value: CNPhoneNumber(stringValue: number))
        
        if let contactsList = try? store.unifiedContacts(matching: predicate, keysToFetch: keys) {
            print(contactsList)
            for contact in contactsList {
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                saveRequest.delete(mutableContact)
                try? store.execute(saveRequest)
            }
        }
    }
    
    @IBAction func registerButtonMethod(_ sender: Any) {
        guard let firstNumber = firstTxf.text else { return }
        guard let lastNumber = secondTxf.text else { return }
        
        store = CNContactStore()
        saveRequest = CNSaveRequest()
        
        let count = (Int(lastNumber) ?? 0) - (Int(firstNumber) ?? 0)
        
        for index in 0...count {
            let needRegNumber = (Int(firstNumber) ?? 0) + index
            print(needRegNumber)
            lblSuccessCount.text = "\(index + 1)"
            
            registerContact(number: "+\(needRegNumber)")
        }
        
        try? store.execute(saveRequest)
    }
    
    
    @IBAction func removeContactsAction(_ sender: Any) {
        guard let firstNumber = firstTxf.text else { return }
        guard let lastNumber = secondTxf.text else { return }
        
//        store = CNContactStore()
//        saveRequest = CNSaveRequest()
        
        let count = (Int(lastNumber) ?? 0) - (Int(firstNumber) ?? 0)
        
        for index in 0...count {
            store = CNContactStore()
            saveRequest = CNSaveRequest()
            let needRegNumber = (Int(firstNumber) ?? 0) + index
            print(needRegNumber)
            lblSuccessCount.text = "\(index + 1)"
            
            removeContact(number: "+\(needRegNumber)")
        }
        
        
    }
    
}

