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
    
  
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var cardsView: CardStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate all classes here
        // CardStack
        // CardView
        // StatusPill
        
        let c = Contact()
        c.getContacts()
        
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.writeToLable), name: mySpecialNotificationKey, object: nil)
        
        if accepted == false {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.go), name: userPressedOK, object: nil)
        } else {
            secGo()
        //    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.secGo), name: userPressedOKTest, object: nil)
        }
        
        
        
        
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        writeToLable()
    }
    
    
    func go() {
        var GlobalMainQueue: dispatch_queue_t {
            return dispatch_get_main_queue()
        }
        
        var GlobalUserInitiatedQueue: dispatch_queue_t {
            return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
        }
        
        
        dispatch_async(GlobalUserInitiatedQueue) {
            let cs = CardStack()
            cs.frame = CGRectMake(10,10,self.view.frame.width-20,self.view.frame.height-50)
            cs.fetchContact()
            
            
            dispatch_async(GlobalMainQueue) {
                
                
                self.view.addSubview(cs)
                
            }
            
        }
        
         //  NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func secGo() {
        var GlobalMainQueue: dispatch_queue_t {
            return dispatch_get_main_queue()
        }
        
        var GlobalUserInitiatedQueue: dispatch_queue_t {
            return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
        }
        
        
        dispatch_async(GlobalUserInitiatedQueue) {
            let cs = CardStack()
            cs.frame = CGRectMake(10,120,self.view.frame.width-25,self.view.frame.height-250)
            cs.fetchContact()
            
            
            dispatch_async(GlobalMainQueue) {
                
                
                self.view.addSubview(cs)
                
            }
            
        }
        
        //  NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    func setLabel() {
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: nil)
    }
    
    
    func writeToLable() {
        countLabel.text = contactCount
    }
    
    
}
