//
//  Frog.swift
//  Quaranteen Project
//
//  Created by Rajat Khare on 5/29/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Frog: UIViewController {
    @IBOutlet weak var frogName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func donePressed(_ sender: Any) {
        if (!frogName.text!.isEmpty) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let childValues = ["frogName" : frogName.text!]
            
            ref.child("users").child(userID).updateChildValues(childValues)
        }
    }
}
