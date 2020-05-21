//
//  ViewController.swift
//  Quaranteen Project
//
//  Created by Rashmi Sharma on 4/22/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit

struct Card {
    var num: Int
    var des: String
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var challengeNum: UILabel!
    @IBOutlet weak var challengeCard: UIView!
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDes: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var doneLabel: UILabel!
    
    @IBOutlet weak var challengePic: UIImageView! // figure out way to add to user's photo gallery then add to photo gallery view
    
    // create array to store multiple challenge cards
    var challenges = [Card]()
    
    var currentIndex = 0
    // create array of descriptions
    var descriptions: [String] = ["Cook a vegetarian meal for your family.", "Bake banana bread.", "Make Dalgona coffee.", "Make your own pasta."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        createCards()
        
       // readCardsFromDisk()       DON'T NEED THIS YET, MAYBE LATER WHEN TRACKING PROGRESS
        
        challengeCard.backgroundColor = UIColor(red: 0.93, green: 0.46, blue: 0.18, alpha: 1.00)
        challengeCard.layer.cornerRadius = 20.0
        cardTitle.layer.cornerRadius = 20.0
        cardDes.layer.cornerRadius = 20.0
        challengeCard.layer.shadowRadius = 20.0
        challengeCard.layer.shadowOpacity = 0.3
        cardTitle.clipsToBounds = true
        cardDes.clipsToBounds = true
        
        doneButton.layer.cornerRadius = 20.0
        doneButton.setTitleColor(UIColor(red: 0.33, green: 0.77, blue: 0.42, alpha: 1.00), for: .normal)
        doneLabel.layer.cornerRadius = 20.0
        doneLabel.clipsToBounds = true
        doneLabel.backgroundColor = UIColor(red: 0.33, green: 0.77, blue: 0.42, alpha: 1.00)
        addPicButton.layer.cornerRadius = 16.0
        //challengeNum.layer.isOpaque = true  FIGURE OUT OPACITY OF TEXT
        
        
    }

    @IBAction func tapDone(_ sender: Any) {
        doneButton.isHidden = true
        // move to next challenge card
        currentIndex = currentIndex + 1
        
        // update labels
        updateLabels()
        
        // update done button
        updateDoneButton()
    }
    
    @IBAction func tapAddPic(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        // create action sheet (specific type of alert that appears in response to action
        let actionSheet = UIAlertController(title: "Challenge Selfie", message: "Add picture of you attempting this challenge!", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            // if camera is enabled on device
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Camera unavailable.") // ADD ALERT HERE INSTEAD
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) // nil handler because no action when pressing cancel
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // to capture image that user has selected/taken
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // info dictionary contains image that was just taken/selected
        // create image object to store this image, select it from info dictionary using predefined key ~originalImage
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // populate TEMPORARY image view on challenge card with this image:
        challengePic.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // REMEMBER TO STATE REASON AS TO WHY WE NEED TO ACCESS
    // USER'S PHOTO LIBRARY AND/OR CAMERA
    // DONE IN INFO.PLIST
    
    func createCards() {
        var i: Int = 1
        print("size des ", descriptions.count)
        for index in 0...descriptions.count - 1 {
            
            let cCard = Card(num: i, des: descriptions[index])
            challenges.append(cCard)
            i += 1
        }
    }
    // store array of challenge cards to disk
    
    // convert array of cards to dictionary so that userdefaults can save the structure
    func saveCardsToDisk() {
        UserDefaults.standard.set(challenges, forKey: "challenges")
        
        let dictArray = challenges.map { (card) -> [String:Any] in
            return ["description": card.des, "num": card.num]
        }
        
        // save dictionary to disk
        UserDefaults.standard.set(dictArray, forKey: "challenges")
    }
    
    // read from disk
    // may need this function when tracking progress
    func readCardsFromDisk(){
        // check to see if there are saved cards
        if let dictArray = UserDefaults.standard.array(forKey: "challenges") as? [[String:Any]] {
            
            let savedCards = dictArray.map { dictionary -> Card in return Card(num: dictionary["num"] as! Int, des: dictionary["description"] as! String )
                
            }
            // load saved cards into array
            challenges.append(contentsOf: savedCards)
        }
    }
    
    func updateLabels() {
        //print(currentIndex)
        //print(challenges.count)
        if currentIndex >= challenges.count {
            print("No more challenges")
        }
        else{
            let currentCard = challenges[currentIndex]
        
        cardDes.text = currentCard.des
        challengeNum.text = String(currentCard.num)
        }
    }
    
    func updateDoneButton() {
        
        doneButton.isHidden = false
        
    }
}
