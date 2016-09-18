//
//  CardStack.swift
//  Torchy
//
//  Created by Alex Cruz on 6/24/16.
//  Copyright © 2016 torchy. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var person: Person! {
        didSet {
            
            // Property Configuration
            let image = UIImage(data: person.image)
            imageView.image = image
            nameLabel.text = person.name
            phoneNumberLabel.text = person.phoneNumber
       
            print(person.name)
        }
    }
    
    // UIImage intializer
    var imageView = UIImageView()
    let nameLabel = UILabel()
    let phoneNumberLabel = UILabel()
    
    
    
    
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
        self.backgroundColor = UIColor.whiteColor()
        
        // Loop through each view that we add it and make some property changes on those view
        for v in [imageView, nameLabel, phoneNumberLabel] {
            // set auto layout programmatically
            v.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(v)
        }
        
        // Now that are subview are ready to layout, lets go through each one and lay them out individually
        
        // imageView
        NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 101, constant: 90).active = true
        
        // HEIGHT - Now the height of the image View is going to be base on the current view size, so its going to be a % of the total view
        NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.9, constant: 0).active = true
        
        
        // Name
        NSLayoutConstraint(item: nameLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: -180).active = true
        NSLayoutConstraint(item: nameLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 7).active = true
        NSLayoutConstraint(item: nameLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        
        // Phone Number
        NSLayoutConstraint(item: phoneNumberLabel, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: -180).active = true
        NSLayoutConstraint(item: phoneNumberLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -7).active = true
        NSLayoutConstraint(item: phoneNumberLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        
        
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        nameLabel.textAlignment = .Left
        
        phoneNumberLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        phoneNumberLabel.textAlignment = .Right
        
        
        // Styling
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        
        self.imageView = UIImageView(frame: CGRectMake(0, 0, 343, 400))
        self.addSubview(self.imageView);
        
        
    }
    
}
