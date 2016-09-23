//
//  CardStack.swift
//  Torchy
//
//  Created by Alex Cruz on 6/24/16.
//  Copyright © 2016 torchy. All rights reserved.
//

import UIKit
import Contacts


class CardStack: UIView {
    
    // Add initializers
    var csPeople = [Person]()
    var threePeople = [Person]()
    var cards: [CardView] = []
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        defaultInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        // fatalError("init(coder:) has not been implemented")
//        defaultInit()
//    }
    
    
    func fetchContact() {
        // Here we add our ppl, this should be done in the ViewController
        
        
//        let contact = Contact()
//        contact.getContacts()
        

     //   let newArray = contact.people[0...20]
        
        if people.count > 0 {
            for person in people {
                csPeople.append(person)
            }
            
        }
        
        if csPeople.count > 0 {
            managePeople(csPeople)
        }
        
    }
    
    
    func managePeople(allPeople: [Person]) {
        
        for person in allPeople[0...2] {
            threePeople.append(person)
            addPerson(person)
        }
        
    }
    
    
    func addPerson(person: Person) {
       
        // Add card to our card stack
        // Create a new card for each person
      
            
         let card = CardView()
            
            card.person = person
            
            
            // cards.append(card)
            
            self.addSubview(card)
            
            card.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: card, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: card, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: card, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0).active = true
            NSLayoutConstraint(item: card, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0).active = true
            
            cards.append(card)
            
            self.sendSubviewToBack(card)
            
            setupTransforms(0)
            
            // Here we will be adding gesture recognizer
        
            if cards.count == 1 {
                card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CardStack.pan(_:))))
            }
        
        
        
    }
    
    // Now setup transform should go through each of the cards and configure the transform so that they layout correctly
    // That means the first view is not going to move and the one under is going to be slightly tilted to the left or right
    
    func setupTransforms(percentCompletion: Double) {
        // Iterate through the cards
        let translationDelta: CGFloat = 6
        
        for (i, card) in cards.enumerate() {
            if i == 0 { continue; }
            
            
            
            var translationA, rotationA, scaleA: CGFloat!
            var translationB, rotationB, scaleB: CGFloat!
            
            
            if i % 2 == 0 {
                translationA = CGFloat(i)*translationDelta
                rotationA = CGFloat(M_PI)/100*CGFloat(i)
                
                translationB = -CGFloat(i-1)*translationDelta
                rotationB = -CGFloat(M_PI)/100*CGFloat(i-1)
            } else {
                translationA = -CGFloat(i)*translationDelta
                rotationA = -CGFloat(M_PI)/100*CGFloat(i)
                
                translationB = CGFloat(i-1)*translationDelta
                rotationB = CGFloat(M_PI)/100*CGFloat(i-1)
            }
            
            scaleA = 1-CGFloat(i)*0.05
            scaleB = 1-CGFloat(i-1)*0.05
            
            let translation = translationA*(1-CGFloat(percentCompletion))+translationB*CGFloat(percentCompletion)
            let rotation = rotationA*(1-CGFloat(percentCompletion))+rotationB*CGFloat(percentCompletion)
            
            let scale = scaleA*(1-CGFloat(percentCompletion))+scaleB*CGFloat(percentCompletion)
            
            
            
            var transform = CGAffineTransformIdentity
            transform = CGAffineTransformTranslate(transform, translation, 0)
            transform = CGAffineTransformRotate(transform, rotation)
            transform = CGAffineTransformScale(transform, scale, scale)
            
            card.transform = transform
            
            
            
        }
        
    }
    
    func setupGestures() {
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for gesture in gestures {
                card.removeGestureRecognizer(gesture)
            }
        }
        
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CardStack.pan(_:))))
        }
    }
    
    
    func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! CardView
        
        let translation = gesture.translationInView(self)
        
        var percent = translation.x / CGRectGetMidX(self.bounds)
        percent = min(percent, 1)
        percent = max(percent, -1)
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: [], animations: { () -> Void in
            self.setupTransforms(abs(Double(percent)))
            }, completion: nil)
        
        if percent > 0.2 {
            card.nopeLabel.alpha = 0
            
            let newPercent = (percent - 0.2)/0.8
            card.likeLabel.alpha = newPercent
            
        } else if percent < -0.2 {
            card.likeLabel.alpha = 0
            
            let newPercent = (abs(percent) - 0.2)/0.8
            card.nopeLabel.alpha = newPercent
        } else {
            card.likeLabel.alpha = 0
            card.nopeLabel.alpha = 0
        }
        
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, translation.x, translation.y)
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI)*percent/30)
        
        card.transform = transform
        
        if gesture.state == .Ended {
            let velocity = gesture.velocityInView(self)
            
            let percentBlockKeep = {
                self.cards.removeAtIndex(self.cards.indexOf(card)!)
                self.csPeople.removeFirst()
                self.threePeople.removeFirst()

                
                self.setupGestures()
                card.removeGestureRecognizer(card.gestureRecognizers![0])
                
                let slope = translation.y / translation.x
                let distance = max(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
                
                let y = distance*sqrt(1+1/(slope*slope))
                let x = y / slope
                
                let normVelX = velocity.x / x
                let normVelY = velocity.y / y
                
                UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelX, options: [], animations: { () -> Void in
                    card.center.x = x
                    }, completion: nil)
                
                UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelY, options: [], animations: { () -> Void in
                    card.center.y = y
                    }, completion: nil)
                
                
                

                
                
            }
            
            
            let percentBlockDelete = {
                self.cards.removeAtIndex(self.cards.indexOf(card)!)
                self.csPeople.removeFirst()
                self.threePeople.removeFirst()
                
                
                self.deleteFromContact(card.nameLabel.text!)
            
                self.setupGestures()
                card.removeGestureRecognizer(card.gestureRecognizers![0])
                
                let slope = translation.y / translation.x
                let distance = max(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
                
                let y = distance*sqrt(1+1/(slope*slope))
                let x = y / slope
                
                let normVelX = velocity.x / x
                let normVelY = velocity.y / y
                
                UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelX, options: [], animations: { () -> Void in
                    card.center.x = x
                    }, completion: nil)
                
                UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelY, options: [], animations: { () -> Void in
                    card.center.y = y
                    }, completion: nil)
                
                
                
            }
            
            
            
            if percent > 0.2 {
                percentBlockKeep()
                
                
                if self.threePeople.isEmpty {
                    self.subviews.forEach({ $0.removeFromSuperview() })
                    self.managePeople(self.csPeople)

                }

                
            } else if percent < -0.2 {
                percentBlockDelete()
                
                if self.threePeople.isEmpty {
                    self.subviews.forEach({ $0.removeFromSuperview() })
                    self.managePeople(self.csPeople)
  
                }
                
                contactCount = String(self.csPeople.count)
                
                let vc = MainViewController()
                vc.setLabel()
                
                
                
                
                
                
                
                
                
                
                
                
                
            } else {
                let normVelX = -velocity.x / translation.x
                let normVelY = -velocity.y / translation.y
                
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    card.likeLabel.alpha = 0
                    card.nopeLabel.alpha = 0
                    }, completion: nil)
                
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: normVelX, options: [], animations: { () -> Void in
                    var transform = CGAffineTransformIdentity
                    transform = CGAffineTransformTranslate(transform, 0, translation.y)
                    card.transform = transform
                    }, completion: nil)
                
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: normVelY, options: [], animations: { () -> Void in
                    var transform = CGAffineTransformIdentity
                    transform = CGAffineTransformTranslate(transform, 0, 0)
                    card.transform = transform
                    }, completion: nil)
            }
            
            
           
            
            
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                self.setupTransforms(0)
                }, completion: nil)
            
            
            
        }
        
       

        
    }
    
    
    
    func deleteFromContact(nameToDelete: String) {
        
        print(nameToDelete)
        
        let store = CNContactStore()
        let predicate = CNContact.predicateForContactsMatchingName(nameToDelete)
        let toFetch = [CNContactEmailAddressesKey]
        
        do{
            let contacts = try store.unifiedContactsMatchingPredicate(predicate,keysToFetch: toFetch)
            guard contacts.count > 0 else{
                print("No contacts found")
                return
            }
            
            guard let contact = contacts.first else{
                return
            }
            
            let req = CNSaveRequest()
            let mutableContact = contact.mutableCopy() as! CNMutableContact
            req.deleteContact(mutableContact)
            
            do{
                try store.executeSaveRequest(req)
                print("Success, You deleted the user")
            } catch let e{
                print("Error = \(e)")
            }
        } catch let err{
            print(err)
        }
    }
    
}
