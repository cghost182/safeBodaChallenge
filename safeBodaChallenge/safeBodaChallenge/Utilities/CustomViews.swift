//
//  CustomViews.swift
//  safeBodaChallenge
//
//  Created by Christian Collazos on 10/2/19.
//  Copyright © 2019 Christian Collazos. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CornerRadiusView: UIView {
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    
    override func awakeFromNib() {
        setUp()
    }
    
    private func setUp(){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
    }
}

@IBDesignable class CornerRadiusButton: UIButton {
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    
    override func awakeFromNib() {
        setUp()
    }
    
    private func setUp(){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
    }
}
