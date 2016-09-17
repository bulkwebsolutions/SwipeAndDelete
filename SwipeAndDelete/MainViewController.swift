//
//  ViewController.swift
//  Torchy
//
//  Created by Alex Cruz on 6/24/16.
//  Copyright © 2016 torchy. All rights reserved.
//

import UIKit
import Contacts

class MainViewController: UIViewController {
    
    var allContainers: [CNContainer] = []
    var results: [CNContact] = []
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContacts()
    }
    
    func getContacts() {

//        let store = CNContactStore()
//        
//        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
//            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
//                if authorized {
//                    self.retrieveContactsWithStore(store: store)
//                }
//            } as! (Bool, Error?) -> Void)
//        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
//            self.retrieveContactsWithStore(store: store)
//        }
        
        
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
            store.requestAccessForEntityType(.Contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store)
                }
            })
        } else if CNContactStore.authorizationStatusForEntityType(.Contacts) == .Authorized {
            self.retrieveContactsWithStore(store)
        }
        
    }
    
    
    func retrieveContactsWithStore(store: CNContactStore) -> [Person] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey]
        
        do {
            
            allContainers = try contactStore.containersMatchingPredicate(nil)
            
        } catch {
            print(error)
        }
        
        
        
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keysToFetch)
                
                //   print(container.name)
                results.appendContentsOf(containerResults)
                
            } catch {
                print("Error fetching results for container")
            }
        }
        
        //
        //        for item in results {
        //            print(item.givenName)
        //        }
        //
        //
        
        for person in results {
            if let unwrapIt = person.thumbnailImageData {
//                let eachContact = Person(name: person.givenName, image: unwrapIt)
//                people.append(eachContact)
            }
            
        }
        
        
        return people
        
        
    }
    

    
}


