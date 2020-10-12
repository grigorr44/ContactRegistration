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

    // MARK: - Interface Builder Outlets
    
    @IBOutlet private weak var firstTxf: UITextField!
    @IBOutlet private weak var secondTxf: UITextField!
    @IBOutlet private weak var lblSuccessCount: UILabel!

    // MARK: - Properties
    
    private var store = CNContactStore()
    private var saveRequest = CNSaveRequest()
    
    // MARK: - Interface Builder Actions
    
    @IBAction private func registerButtonMethod(_ sender: Any) {
        guard let firstNumber = firstTxf.text,
            let countText = secondTxf.text,
            let count = Int(countText),
            count > 0 else { return }
        store = CNContactStore()
        saveRequest = CNSaveRequest()
        for index in 0 ..< count {
            let needRegNumber = (Int(firstNumber) ?? 0) + index
            print(needRegNumber)
            lblSuccessCount.text = "\(index + 1)"
            registerContact(number: "+\(needRegNumber)")
        }
        exequte(saveRequest)
    }
    
    @IBAction private func removeContactsAction(_ sender: Any) {
        guard let firstNumber = firstTxf.text,
            let countText = secondTxf.text,
            let count = Int(countText),
            count > 0 else { return }
        for index in 0 ..< count {
            store = CNContactStore()
            saveRequest = CNSaveRequest()
            let needRegNumber = (Int(firstNumber) ?? 0) + index
            print(needRegNumber)
            lblSuccessCount.text = "\(index + 1)"
            removeContact(number: "+\(needRegNumber)")
        }
    }
    
    @IBAction private func removeAllaction(_ sender: UIButton) {
        let keys = [CNContactPhoneNumbersKey]
        let containerID = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerID)
        var contacts = [CNContact]()
        do {
            try contacts = store.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
        } catch {
            print(error, "---")
        }
        for contact in contacts {
            if let mutableCopy = contact.mutableCopy() as? CNMutableContact {
                saveRequest.delete(mutableCopy)
            }
        }
        exequte(saveRequest)
    }
    
    // MARK: - Helper Methods
    
    private func registerContact(number: String) {
        let contact = CNMutableContact()
        contact.givenName = "\(number)"
        contact.phoneNumbers.append(CNLabeledValue(label: "GG", value: CNPhoneNumber(stringValue: number)))
        saveRequest.add(contact, toContainerWithIdentifier: nil)
    }
    
    private func removeContact(number: String) {
        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: number))
        let keys = [CNContactPhoneNumbersKey as CNKeyDescriptor]
        if let contactsList = try? store.unifiedContacts(matching: predicate, keysToFetch: keys) {
            print(contactsList)
            for contact in contactsList {
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                saveRequest.delete(mutableContact)
                exequte(saveRequest)
            }
        }
    }
    
    private func exequte(_ saveRequest: CNSaveRequest) {
        do {
            try self.store.execute(self.saveRequest)
        } catch {
            print(error, "---")
        }
    }
}

