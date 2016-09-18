//
//  CardStack.swift
//  Torchy
//
//  Created by Alex Cruz on 6/24/16.
//  Copyright © 2016 torchy. All rights reserved.
//

import UIKit



class CardStack: UIView {
    
    // Add initializers
    var people = [Person]()
    
    // This is base on how it class and subclass initializers relate to its super class
    
    
    // Add Array of card view
  
    var cards: [CardView] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // fatalError("init(coder:) has not been implemented")
        defaultInit()
    }
    
    
    func defaultInit() {
        // Here we add our ppl, this should be done in the ViewController
 
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
        
        
        let contact = Contact()
        contact.getContacts()
        

        let newArray = contact.people[0..<20]
        
        for person in newArray {
            addPerson(person)
          //  people.append(person)
        }
        
        
        
    }
    
    
    func addPerson(person: Person) {
       
        // Add card to our card stack
        // Create a new card for each person
        
      //  for person in people {
            
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
        
            
     //   }
        
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
    
    func pan(gesture: UIPanGestureRecognizer) {
        // Lets cast the view that owns this gesture
        let card = gesture.view! as! CardView
        
        let translation = gesture.translationInView(self)
        
        // Calculate the % completion
        var percent = translation.x / CGRectGetMidX(self.bounds)
        percent = min(percent, 1)
        percent = max(percent, -1)
        
        
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations:
            {
                self.setupTransforms(abs(Double(percent)))
            }, completion: nil)
        
        
        
        // Add rotation
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, translation.x, translation.y)
        //    print("First \(transform)")
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI)*percent/30)
        //     print("Second \(transform)")
        card.transform = transform
        
        
        
        
        card.transform = CGAffineTransformMakeTranslation(translation.x, translation.y)
        
        
        // Return card to starting point
        if gesture.state == .Ended {
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [],
                                       
                                       animations: {
                                        
                                        card.transform = CGAffineTransformIdentity
                                        
                }, completion: nil)
            
            UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations:
                {
                    self.setupTransforms(0)
                }, completion: nil)
        }
        
    }
    
}
