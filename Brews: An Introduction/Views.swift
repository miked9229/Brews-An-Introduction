//
//  Views.swift
//  Brews: An Introduction
//
//  Created by Michael Doroff on 7/29/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit


class GuestLogIn: UIButton {
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var GuestLogInButton: UIView = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = UIColor(colorLiteralRed: 61/255, green: 91/255, blue: 151/255, alpha: 5.0)
        loginButton.setTitle("Login As Guest", for: .normal)
        loginButton.titleLabel?.textColor = .black

        return loginButton
    }()
    
    private func setupViews() {
        addSubview(GuestLogInButton)
    
        
   
    
    }
    
}
