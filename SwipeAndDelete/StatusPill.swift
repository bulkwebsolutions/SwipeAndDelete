//
//  StatusPill.swift
//  SwipeAndDelete
//
//  Created by Alex Cruz on 9/18/16.
//  Copyright © 2016 swipeanddelete. All rights reserved.
//

import UIKit

class StatusPill : UIView {
    var color: UIColor! {
        didSet {
            self.layer.borderColor = color.CGColor
            self.label.textColor = color
            
        }
    }
    
    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
        }
    }
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    func defaultInit() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: -30).active = true
        NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: -30).active = true
        label.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        
        self.layer.borderWidth = 3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.size.height/2
    }
}
