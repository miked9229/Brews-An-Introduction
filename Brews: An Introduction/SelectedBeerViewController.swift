//
//  SelectedBeerViewController.swift
//  Brews
//
//  Created by Michael Doroff on 5/29/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import ExpandableLabel


// MARK: SelectedBeerViewController: UIViewController

class SelectedBeerViewController: UIViewController {
    
    // MARK: Properties
    var selectedBeer: FIRDataSnapshot!
    var isMatch = false
    var beerArray = [FIRDataSnapshot]()
    var matchBeerArray = [String]()
    var currentUser: String!
    
    @IBOutlet weak var organicIndicator: UILabel!
    @IBOutlet weak var alcoholByVolumeIndicator: UILabel!
    @IBOutlet weak var beerColorIntensityIndicator: UILabel!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet var beerDescription: UITextView!
 
    @IBOutlet var descriptionOfBeer: ExpandableLabel!
    
    let storage = FIRStorage.storage()
    @IBOutlet weak var UserFavoritesBar: UIButton!
    let activityIndicator = UIActivityIndicatorView()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        beerDescription.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpBeer()
       listenForUserAuthentication()
       disableFavoritesButton()
      self.navigationController?.navigationBar.topItem?.title = ""
      beerDescription.scrollRangeToVisible(NSRange(location:0, length:0))
//      beerDescription.isScrollEnabled = true
//      beerDescription.contentOffset.y = 0

       

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        beerDescription.setContentOffset(CGPoint.zero, animated: false)
    }

    
    fileprivate func setUpBeer() {
        let snapshotValue = selectedBeer.value as? [String: AnyObject]
        beerName.text = snapshotValue?["name"] as! String?
        var style = snapshotValue?["style"] as? [String: AnyObject]
        
        if let alcoholContent = style?["abvMax"] as! String? {
//            selectedBeerAlcContent.text = alcoholContent + "%"
        } else {
//            selectedBeerAlcContent.text = "Not available"
        }
        

        
    }
    
    fileprivate func disableFavoritesButton() {
       checkIfBeerAlreadyOnList()

    
    }
    
//    fileprivate func downloadImage() {
//      Deperecated Method
//        let storageRef = storage.reference()
//        let snapshotValue = selectedBeer.value as? [String: AnyObject]
//        let id = snapshotValue?["id"] as! String?
//        let beerRef = storageRef.child( id! + ".jpg")
//      
//        setUpActivityIndicator()
//        activityIndicator.startAnimating()
//        
//        beerRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
//            if error != nil {
//               return
//            }
//            self.activityIndicator.stopAnimating()
//            let image = UIImage(data: data!)
//            self.beerImage.image = image
//            
//        }
//    
//    }
    
    public func listenForUserAuthentication() {
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                // 3
                self.currentUser = user?.email
                
            }
        }
    }

    
    @IBAction func addToFavorites(_ sender: Any) {
        
       var userDict = [String : [String: Any]]()
       let ref = FIRDatabase.database().reference()
       let selectedBeerDict = selectedBeer.value as? [String: Any]
       let userid = FIRAuth.auth()!.currentUser?.uid
 
        
       userDict["beer"] = selectedBeerDict!
        
       ref.child("users").child("users/individualusers/").child(userid!).childByAutoId().updateChildValues(userDict)
        
       navigationController?.popToRootViewController(animated: true)
        
    }
    fileprivate func checkIfBeerAlreadyOnList()   {
        let ref = FIRDatabase.database().reference()
        let userid = FIRAuth.auth()!.currentUser?.uid
        ref.child("users/users/individualusers").child(userid!).observe(.value) { (snapshot: FIRDataSnapshot) in
            for each in snapshot.children {
                self.beerArray.append(each as! FIRDataSnapshot)
              
            }
            for each in self.beerArray {
                var snap = each.value as? [String: AnyObject]
                var beer = snap?["beer"] as? [String:AnyObject]
                let name = beer?["name"] as? String
                if let name = name {
                    if name == self.beerName.text {
                        self.UserFavoritesBar.isEnabled = false
                        self.navigationController?.navigationBar.topItem?.title = "This beer is on your favorite list"
                        
                     
                    }
                }
                
            }
        }
    }

    fileprivate func setUpActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(activityIndicator)
    
    }

}
