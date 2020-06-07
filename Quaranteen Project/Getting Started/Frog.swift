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

class Frog: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var frogName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        frogName.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
       {
           textField.resignFirstResponder()
           return true
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
        } else {
            let alert = UIAlertController(title: "Frog", message: "Please add a name for your frog", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
