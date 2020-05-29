//
//  ProfileViewController.swift
//  Quaranteen Project
//
//  Created by Rashmi Sharma on 5/28/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        editProfileButton.layer.cornerRadius = 20.0
        signOutButton.layer.cornerRadius = 20.0
        
        
    }
    
    @IBAction func tappedEditProfile(_ sender: Any) {
    }
    
    @IBAction func tappedSignOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          print("User signed out")
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
