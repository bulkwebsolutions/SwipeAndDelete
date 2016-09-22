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
        
        var GlobalMainQueue: dispatch_queue_t {
            return dispatch_get_main_queue()
        }
        
        var GlobalUserInteractiveQueue: dispatch_queue_t {
            return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
        }
        
        var GlobalUserInitiatedQueue: dispatch_queue_t {
            return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
        }
        
        var GlobalUtilityQueue: dispatch_queue_t {
            return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
        }
        
        var GlobalBackgroundQueue: dispatch_queue_t {
            return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
        }
        
        
        dispatch_async(GlobalUserInitiatedQueue) {
            let cs = CardStack()
            cs.frame = CGRectMake(10,10,self.view.frame.width-25,self.view.frame.height-50)
            cs.fetchContact()
            
           
            dispatch_async(GlobalMainQueue) {
                
                
                self.view.addSubview(cs)
               
            }
            
        }
        
        
        
        
        
        
        writeToLable()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.writeToLable), name: mySpecialNotificationKey, object: nil)
    }
    
    
    
    
    
    
    
    func setLabel() {
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: nil)
    }
    
    
    func writeToLable() {
        countLabel.text = contactCount
    }
    
    
}
