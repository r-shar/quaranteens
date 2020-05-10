//
//  ViewController.swift
//  Quaranteen Project
//
//  Created by Rashmi Sharma on 4/22/20.
//  Copyright © 2020 Rashmi Sharma. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var challengeCard: UIView!
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDes: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var doneLabel: UILabel!
    
    @IBOutlet weak var challengePic: UIImageView! // figure out way to add to user's photo gallery then add to photo gallery view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    
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
    
    }

    
    @IBAction func tapDone(_ sender: Any) {
        doneButton.isHidden = true
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
}

