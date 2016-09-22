//
//  Contact.swift
//  SwipeAndDelete
//
//  Created by Alex Cruz on 9/17/16.
//  Copyright © 2016 swipeanddelete. All rights reserved.
//

import Foundation
import Contacts

var contactCount = String()



class Contact {
    
var allContainers: [CNContainer] = []
var results: [CNContact] = []
var people = [Person]()


    func getContacts() {
        
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


    func retrieveContactsWithStore(store: CNContactStore) {
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
        
        if allContainers.count > 0 {
            fetchContactsFromContainer(contactStore, keysToFetch: keysToFetch)
        }
        
        
    }
    
    
    func fetchContactsFromContainer(contactStore: CNContactStore, keysToFetch: [CNKeyDescriptor]) {
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keysToFetch)
                results.appendContentsOf(containerResults)
                
            } catch {
                print("Error fetching results for container")
            }
        }
        
        if results.count > 0 {
            addResultsToArray()
        }
        
    }
    
    
    func addResultsToArray() {
        
        for person in results {
            
            let test = NSData() 
            
            for ContctNumVar: CNLabeledValue in person.phoneNumbers
            {
                
                let MobNumVar  = (ContctNumVar.value as! CNPhoneNumber).valueForKey("digits") as? String
                let eachContact = Person(name: person.givenName, image: person.thumbnailImageData ?? test, phoneNumber: MobNumVar!)
                people.append(eachContact)
                
               // print(eachContact)
            }
            
        }
        
       contactCount = String(people.count)
    }

}




