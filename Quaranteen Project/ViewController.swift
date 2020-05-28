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
    
    @IBOutlet weak var selectCatButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var challengeButtons: [UIButton]!
    
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
    // create array of challenges
    var foodChallenges: [String] = ["Cook a vegetarian meal for your family.", "Bake banana bread.", "Make Dalgona coffee.", "Make your own pasta."]
    
    var exerciseChallenges: [String] = ["Do mountain climbers for one minute.", "Do 20 pushups.", "Learn a tiktok dance.", "Go on a run around your neighborhood.", "Do 10 burpies followed by 20 squats."]
    
    var connectChallenges: [String] = ["Reconnect with an old friend.", "Send an appreciation email to your favorite teacher.", "Video chat with your friends.", "Watch a movie with friends.", "Invite and play an online multiplayer game with your friends (check out Skribbl)."]
    
    var mhChalenges: [String] = ["Journal for 15 minutes.", "Make a note of five things you are grateful for.", "Meditate for 15 minutes.", "Write a letter to your future self.", "Draw something random.", "Start a gratitude journal.", "Make a dream board.", "Write a letter to your past self.", "Meditate for 10 minutes.", "Say three affirmations.", "Go on a walk to increase endorphins.", "Spend an hour away from any screens."]
    
    var workChallenges: [String] = ["Make a to-do list for the week (and try your best to follow through with it!)", "Read 30 pages (and try to do it daily!)", "Turn off your devices and focus on your work for an hour."]
    
    var diyChallenges: [String] = ["Try following an origami video.", "Draw your favorite movie or TV show character.", "Draw a self portrait."]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        createCards(catArray: foodChallenges)
        
       // readCardsFromDisk()       DON'T NEED THIS YET, MAYBE LATER WHEN TRACKING PROGRESS
        
        self.doneView.layer.cornerRadius = 20.0
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
        
        stackView.spacing = 0.0
        challengeButtons.forEach { (button) in
            button.backgroundColor = UIColor(red: 0.93, green: 0.46, blue: 0.18, alpha: 1.00)
        }
        
        selectCatButton.backgroundColor = UIColor(red: 0.33, green: 0.77, blue: 0.42, alpha: 1.00)
        
    }
    
    @IBOutlet var doneView: UIView!
    
    @IBAction func tapDone(_ sender: Any) {
        
        doneButton.isHidden = true
        self.view.addSubview(doneView)
        doneView.center = self.view.center
        
        
    }
    
    @IBAction func doneViewDone(_ sender: Any) {
        self.doneView.removeFromSuperview()
        
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
    
    func createCards(catArray: Array<String>) {
        
        var i: Int = 1
            // print("size des ", foodChallenges.count)
            for index in 0...catArray.count - 1 {
                
                let cCard = Card(num: i, des: catArray[index])
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
    
    @IBAction func handleSelection(_ sender: UIButton) {
        challengeButtons.forEach { (button) in
            UIView.animate(withDuration: 0.2) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //what to do when a challenge category is selected
    // we want to display different challenge deck (switch array)
    enum Categories: String {
        case artsNCrafts = "Arts & Crafts"
        case cooking = "Cooking"
        case connections = "Connections"
        case fitness = "Fitness"
        case mentalHealth = "Mental Health"
        case productivity = "Productivity"
    }
    @IBAction func cityTapped(_ sender: UIButton) {
        guard let categoryTitle = sender.currentTitle, let category = Categories(rawValue: categoryTitle) else {
            return
        }
        
        switch category {
        case .artsNCrafts:
            selectCatButton.setTitle("ARTS & CRAFTS", for: .normal)
            challenges.removeAll()
            currentIndex = 0
            
            createCards(catArray: diyChallenges)
            updateLabels()
            updateDoneButton()
        case .connections:
            selectCatButton.setTitle("CONNECTIONS", for: .normal)
            challenges.removeAll()
            currentIndex = 0
            
            createCards(catArray: connectChallenges)
            updateLabels()
            updateDoneButton()
        case .cooking:
            selectCatButton.setTitle("COOKING", for: .normal)
            challenges.removeAll()
            currentIndex = 0
            
            createCards(catArray: foodChallenges)
            updateLabels()
            updateDoneButton()
        case .fitness:
            selectCatButton.setTitle("FITNESS", for: .normal)
            challenges.removeAll()
            currentIndex = 0
            
            createCards(catArray: exerciseChallenges)
            updateLabels()
            updateDoneButton()
        case .mentalHealth:
            selectCatButton.setTitle("MENTAL HEALTH", for: .normal)
            challenges.removeAll()
            currentIndex = 0
            
            createCards(catArray: mhChalenges)
            updateLabels()
            updateDoneButton()
        case .productivity:
            selectCatButton.setTitle("PRODUCTIVITY", for: .normal)
            challenges.removeAll()
            currentIndex = 0
            
            createCards(catArray: workChallenges)
            updateLabels()
            updateDoneButton()
        }
    challengeButtons.forEach { (button) in
        UIView.animate(withDuration: 0.2) {
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    }
    
}
