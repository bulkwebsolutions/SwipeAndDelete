//
//  ViewController.swift
//  Torchy
//
//  Created by Alex Cruz on 6/24/16.
//  Copyright © 2016 torchy. All rights reserved.
//

import UIKit
import Contacts

let mySpecialNotificationKey = "oneKey"

class MainViewController: UIViewController {
    
  
//    var people = [Person]()
    @IBOutlet var countLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writeToLable()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.writeToLable), name: mySpecialNotificationKey, object: nil)
        
//        let contact = Contact()
//        contact.getContacts()
//        
//        let cardClass = CardStack()
//        for person in contact.people {
//            
//            people.append(person)
//        }
//        
//        cardClass.addPerson(people)
    }
    
    
    
    func setLabel() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: nil)
        
        
        
    }
    
    
    func writeToLable() {
        countLabel.text = contactCount
    }
    
    
}
