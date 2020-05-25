//
//  SelectChallengeViewController.swift
//  Quaranteen Project
//
//  Created by Can Dang on 2020-05-24.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit

class SelectChallengeViewController: UIViewController {

    @IBOutlet weak var fitnessButton: UIButton!
    @IBOutlet weak var mentalHealthButton: UIButton!
    @IBOutlet weak var connectionsButton: UIButton!
    @IBOutlet weak var cookingButton: UIButton!
    @IBOutlet weak var productivityButton: UIButton!
    @IBOutlet weak var artsButton: UIButton!
    
    @IBAction func selectCooking(_ sender: Any) {
        //change whether it's selected:
        if (cookingButton.isSelected) {
            cookingButton.isSelected = false
        } else {
            cookingButton.isSelected = true
        }
    }
    
    @IBAction func selectFitness(_ sender: Any) {
        if (fitnessButton.isSelected) {
            fitnessButton.isSelected = false
        } else {
            fitnessButton.isSelected = true
        }
    }
    
    @IBAction func selectConnections(_ sender: Any) {
        if (connectionsButton.isSelected) {
            connectionsButton.isSelected = false
        } else {
            connectionsButton.isSelected = true
        }
    }
    
    @IBAction func selectArts(_ sender: Any) {
        if (artsButton.isSelected) {
            artsButton.isSelected = false
        } else {
            artsButton.isSelected = true
        }
    }
    
    @IBAction func selectMentalHealth(_ sender: Any) {
        if (mentalHealthButton.isSelected) {
            mentalHealthButton.isSelected = false
        } else {
            mentalHealthButton.isSelected = true
        }
    }
    
    @IBAction func selectProductivity(_ sender: Any) {
        if (productivityButton.isSelected) {
            productivityButton.isSelected = false
        } else {
            productivityButton.isSelected = true
        }
    }
    
    /*When user clicks next button, check which buttons are selected and store those in userDefaults */
    @IBAction func clickNext(_ sender: Any) {
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
