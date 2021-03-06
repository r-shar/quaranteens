//
//  SelectChallengeViewController.swift
//  Quaranteen Project
//
//  Created by Charlize Dang on 2020-05-24.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit
import Firebase

class SelectChallengeViewController: UIViewController {

    @IBOutlet weak var fitnessButton: UIButton!
    @IBOutlet weak var mentalHealthButton: UIButton!
    @IBOutlet weak var connectionsButton: UIButton!
    @IBOutlet weak var cookingButton: UIButton!
    @IBOutlet weak var productivityButton: UIButton!
    @IBOutlet weak var artsButton: UIButton!
    
    let defaults = UserDefaults.standard

    
    @IBAction func selectCooking(_ sender: Any) {
        //change whether it's selected:
        cookingButton.isSelected = !cookingButton.isSelected
    }
    
    @IBAction func selectFitness(_ sender: Any) {
        fitnessButton.isSelected = !fitnessButton.isSelected
    }
    
    @IBAction func selectConnections(_ sender: Any) {
        connectionsButton.isSelected = !connectionsButton.isSelected
    }
    
    @IBAction func selectArts(_ sender: Any) {
        artsButton.isSelected = !artsButton.isSelected
    }
    
    @IBAction func selectMentalHealth(_ sender: Any) {
        mentalHealthButton.isSelected = !mentalHealthButton.isSelected
    }
    
    @IBAction func selectProductivity(_ sender: Any) {
        productivityButton.isSelected = !productivityButton.isSelected
    }
    
    /*When user clicks next button, check which buttons are selected and store those in userDefaults under keyname goals */
    //try to limit number of goals to 3, make sure that they select at least 1 challenge
    @IBAction func clickNext(_ sender: Any) {
        var goals = [String]()
        if (fitnessButton.isSelected) {
            goals.append("fitness")
        }
        if (mentalHealthButton.isSelected) {
            goals.append("mental health")
        }
        if (connectionsButton.isSelected) {
            goals.append("connections")
        }
        if (cookingButton.isSelected) {
            goals.append("cooking")
        }
        if (productivityButton.isSelected) {
            goals.append("productivity")
        }
        if (artsButton.isSelected) {
            goals.append("arts & crafts")
        }
        
        //make sure they select at least 1:
        if (goals.count == 0) {
            let alert = UIAlertController(title: "Challenge", message: "Please select a challenge", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //make sure they don't select more than 3:
        if (goals.count > 3) {
            let alert = UIAlertController(title: "Challenges", message: "Please don't select more than three challenges", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //add challenges to firebase:
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        //get their user id to store data:
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let childValues = ["challenges" : goals]
        ref.child("users").child(userID).updateChildValues(childValues)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
