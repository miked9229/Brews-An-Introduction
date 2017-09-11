//
//  ViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/13/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import FirebaseDatabase


// MARK: LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UINavigationControllerDelegate

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    var currentUser: String!
   
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var googleButton: GIDSignInButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        let margins = view.layoutMarginsGuide
        
        setUpBackGroundImage()
        
        let googleButton = GIDSignInButton()
        googleButton.style = .wide
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleButton)
       
        
        let loginButton = FBSDKLoginButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        view.addSubview(loginButton)

        loginButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: view.frame.height * 0.758).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        
        googleButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5).isActive = true
        googleButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        googleButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        

        
        
        let guestLoginButton = UIButton(type: .system)
        guestLoginButton.translatesAutoresizingMaskIntoConstraints = false
        guestLoginButton.backgroundColor = UIColor(colorLiteralRed: 61/255, green: 91/255, blue: 151/255, alpha: 10.0)
        guestLoginButton.setTitle("Login As Guest", for: .normal)
        guestLoginButton.titleLabel?.textColor = .white
        guestLoginButton.addTarget(self, action: #selector(signIntoFirebaseAnnonymously), for: .touchUpInside)
        view.addSubview(guestLoginButton)

        
        guestLoginButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 5).isActive = true
        guestLoginButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        guestLoginButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
  
        
        listenForUserAuthentication()
  
    }
    

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        showEmailAddress()
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }

    
// MARK: Configure UI Elements
    


    
    fileprivate func setUpBackGroundImage() {
        let background = UIImage(named: "BackgroundImage")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
    }

    
    


// MARK: Firebase Methods
    
    func signIntoFirebaseAnnonymously() {
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
              self.performSegue(withIdentifier: "loginToList", sender: nil)
        }
    }
    
    
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else { return}
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            
            if error != nil {
                print("Something went wrong", error ?? "")
            }
            
            print("Sucessfully logged in with users", user ?? "")
            
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {(connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request")
                return
            }
            
        }
        
    }
    
// MARK: Method that Segues past Login Screen For Users
    
    public func listenForUserAuthentication() {
        // TODO: Figure out a way to only have this method called once
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                // 3
               self.performSegue(withIdentifier: "loginToList", sender: nil)

            }
        }
    }

}
